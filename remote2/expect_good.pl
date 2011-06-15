#!/usr/bin/perl
use warnings;
use strict;

$SIG{__WARN__} = sub { die @_ };

use Cwd 'abs_path','chdir';
use File::Basename;
use XML::Simple;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

### Windows:
# putty test@10.0.0.232 -pw test1234 -m d:/run_commands

### we need: host, user, pass (if user is empty, it means that we use a publickey. Pass may be missing too in this case)
### optional: prompt, work_dir, timeout, (question, answer), connect_from, connection_type, publickey
# my %machine1 = (
#     connection => {
# 	connection_type => 'what protocol are we using to connect (default shh)',
# 	load_profile => 'if we should load the remote profile at login. Probably ssh only (default no)',
# 	publickey => 'path to the public key (default none)',
# 	pass => 'connection pass',
# 	user => 'connection user',
# 	host => 'ip or hostname',
# 	prompt => 'prompt or empty (we will try to guess it)',
# 	work_dir => 'where to save files or empty (we will try $TMP/mind)',
# 	timeout => 'how long to wait before we bailout (default 5 sec)',
# 	extra =>
# 	  [
# 	    { question => 'do you expect anything to be asked before the prompt',
# 	      answer => 'this is what we will send' },
# 	    { question => 'other q', answer => 'an answer' },
# 	    { question => undef, answer => '' },
# 	  ],
# 	connect_from => 'an already defined machine from where we can connect (default is local)',
#     },
#     applications =>
# 	[ { app_name => 'type of application',
# 	    logs => ['path1', 'path2'],
# 	    status => 'enable/disable',
# 	  },
# 	  { app_name => 'other application',
# 	    logs => ['some_path', 'a_path'],
# 	    status => 'enable/disable',
# 	  },
# 	],
#     status => 'enable/disable',
#     emails => ['email1', 'email2', 'email3'],
#   );
# hash_to_xmlfile (\%machine1, "machine.xml");
# print Dumper(xmlfile_to_hash("machine.xml"));
# exit 1;

BEGIN {
    my $path_prefix = (fileparse(abs_path($0), qr/\.[^.]*/))[1]."";
    my $need= "$path_prefix/instantclient_11_2/";
    my $ld= $ENV{LD_LIBRARY_PATH};
    if(  ! $ld  ) {
        $ENV{LD_LIBRARY_PATH}= $need;
    } elsif(  $ld !~ m#(^|:)\Q$need\E(:|$)#  ) {
        $ENV{LD_LIBRARY_PATH} .= ':' . $need;
    } else {
        $need= "";
    }
    if(  $need  ) {
        exec 'env', $^X, $0, @ARGV;
    }
}

my $script_dir = (fileparse(abs_path($0), qr/\.[^.]*/))[1]."";
use lib (fileparse(abs_path($0), qr/\.[^.]*/))[1]."/our_perl_lib/lib";

use Exception::Class (
  'MyException' => {
	description => 'General'
    },
  'ExceptionTimeout' => {
	isa => 'MyException', 
	description => 'timeout'
    }
);

use Expect;
$Expect::Multiline_Matching = 1;
# $Expect::Debug = 1;

my $exp = new Expect;
$exp->log_stdout(1);

my $timeout = 5;
my $max_wait_timeout = 60;
my $max_running_timeout = 300;
my $machines_path = "$script_dir/networks";
my $prompt;
my @prompts = ();

sub xmlfile_to_hash {
    my $file = shift;
    my $xml = new XML::Simple;
    return $xml->XMLin("$file");
}

sub hash_to_xmlfile {
    my ($hash, $name) = @_;
    my $xs = new XML::Simple();
    my $xml = $xs->XMLout($hash,
		    NoAttr => 1,
		    RootName => "machine",
		    OutputFile => $name
		    );
}
sub generate_random_string {
  my $length_of_randomstring=shift;
  my @chars=('a'..'z','A'..'Z','0'..'9','_');
  my $random_string;
  foreach (1..$length_of_randomstring) {
    $random_string.=$chars[rand @chars];
  }
  return $random_string;
}

sub guess_promp {
  print "Try to guess prompt.\n";
  my ($prompt1, $prompt2) = "";
  my $retries = 0;
  $prompt1 = $exp->before();
  $exp->clear_accum();

  while ($retries < 10 ) {
    $exp->send(" \n");
    $exp->expect($timeout);
    $prompt2 = $exp->before();
    $prompt2 =~ s/^\s*\r\n//smg;
    print "\n".Dumper (quotemeta $prompt1, quotemeta $prompt2);
    if (quotemeta $prompt1 eq quotemeta $prompt2) {
      $prompt = $prompt1;
      print "Found prompt: $prompt.\n";
      $exp->clear_accum();
      return;
    }
    $prompt1 = $prompt2;
    $exp->clear_accum();
  }

  MyException->throw( error => 'Could not find prompt.\n' );
}

sub exec_shell_command {
  my $cmd = shift;
  my $ok = 0;
  print "Run command $cmd with prompt $prompt.\n";
  $exp->send("$cmd\n");
  my $ret = $exp->expect(
	      $timeout,
              [quotemeta $prompt,
                sub {print "Command is finished.\n";$ok++;}
	       ],
              [ eof =>
                sub {MyException->throw( error => "ERROR: eof could not execute command: $cmd.\n");}
               ],
              [ timeout =>
                sub {
		  if ($exp->before() eq "") {$max_wait_timeout -= $timeout;print "Nothing is happening...\n";}
		  else {$max_running_timeout -= $timeout; print "Still running...\n";}
		  ExceptionTimeout->throw( error => "ERROR: timeout waiting executing command: $cmd.\n") if $max_wait_timeout <= 0;
		  ExceptionTimeout->throw( error => "ERROR: timeout running executing command: $cmd.\n") if $max_running_timeout <= 0;
		  $exp->clear_accum();
		  exp_continue;
		}
               ],
              );
  MyException->throw( error => "Could not run command.\n") if ! $ok;
  return $exp->before();
}

sub new_bash_prompt {
  my $new_prompt = "mind_".generate_random_string(6)."_ ";
  $exp->send("bash\nexport PS1=\"$new_prompt\";export PROMPT_COMMAND=\"\"\n");
  my $ret = $exp->expect($timeout, $new_prompt);
  MyException->throw( error => "Could not set prompt.\n") if ! defined $ret;
  $prompt = $new_prompt;
  print "New prompt set to $prompt.\n";
  push @prompts, $prompt;
}

sub start_local_bash {
  $exp->spawn("bash") or MyException->throw( error => "Cannot spawn bash: $!\n");
  my $ret = $exp->expect($timeout, $prompt);
  guess_promp if ! defined $ret;
  push @prompts, $prompt;
}

sub logout_ssh {
  $prompt = pop @prompts;
  exec_shell_command("exit");
  $prompt = pop @prompts;
  exec_shell_command("exit");
}

sub login_ssh {
  my ($user, $pass, $host, $extra_question, $extra_annswer) = @_;
  my $cmd = "ssh $user\@$host";
  my $no_profile = "-t 'bash --noprofile --norc'";
  $exp->send("$cmd $no_profile\n");
  my $ok;
  $extra_question = generate_random_string(200) if ! defined $extra_question;

  my $ret = $exp->expect(
	      $timeout,
              [quotemeta $prompt,
                sub {$ok = 1; print "Logged in.\n";}
	       ],
              [ qr/Are you sure you want to continue connecting ?\(yes\/no\)\? ?/,
                sub {$exp->send("yes\n"); exp_continue;}
               ],
              [ quotemeta "$extra_question",
                sub {$ok = 1; $exp->send("$extra_annswer\n"); exp_continue;}
               ],
              [ "$user\@$host\'s password: ",
                sub {$exp->send("$pass\n"); exp_continue;}
               ],
              [ eof =>
                sub {
                  if ($ok) {MyException->throw( error => "ERROR: premature EOF in login.\n");} else {
                    MyException->throw( error => "ERROR: could not login.\n");}
                }
               ],
              );
  guess_promp if ! defined $ret || ! $ok;
  push @prompts, $prompt;
  new_bash_prompt;
}

sub stop_local_bash {
  $exp->send("exit\n");
  my $ret = $exp->expect(
	      $timeout,
              [ eof =>
                sub {print "Closed console. Bye.\n";}
               ],
              [ timeout =>
                sub {MyException->throw( error => "ERROR: timeout could not close console.\n");}
               ],
              );
}

sub print_buffers {
  print "\n\n".Dumper($exp->before(), $exp->match(), $exp->after())."\n\n";
}

eval {
## local
$prompt = '[wiki@localhost remote2]$ ';
start_local_bash;

## remote
$prompt = 'bash-2.05$ ';
# login_ssh("test", "test1234", "10.0.0.232", "ORACLE_SID = [NOT_SET] ? ", "BILL1022");
login_ssh("test", "test1234", "10.0.0.232");

$prompt = 'bash-4.2$ ';
login_ssh("cristi", "cristi", "10.0.0.99");

$prompt = 'bash-2.05$ ';
# login_ssh("test", "test1234", "10.0.0.232", "ORACLE_SID = [NOT_SET] ? ", "BILL1022");
login_ssh("test", "test1234", "10.0.0.232");

$prompt = 'bash-4.2$ ';
login_ssh("cristi", "cristi", "10.0.0.99");

$prompt = 'bash-2.05$ ';
# login_ssh("test", "test1234", "10.0.0.232", "ORACLE_SID = [NOT_SET] ? ", "BILL1022");
login_ssh("test", "test1234", "10.0.0.232");

$prompt = 'bash-4.2$ ';
login_ssh("cristi", "cristi", "10.0.0.99");

$prompt = 'bash-2.05$ ';
# login_ssh("test", "test1234", "10.0.0.232", "ORACLE_SID = [NOT_SET] ? ", "BILL1022");
login_ssh("test", "test1234", "10.0.0.232");


## remote commands
my $res = exec_shell_command("ls /");
print Dumper($res);
pop @prompts;
logout_ssh;
logout_ssh;
logout_ssh;
logout_ssh;
logout_ssh;
logout_ssh;
logout_ssh;

## local end
stop_local_bash;
$exp->soft_close();
};

# eval { MyException->throw( error => 'I feel funny.' ) };
# if ( my $e = Exception::Class->caught('MyException2') ) {print $e->error, " 1\n", $e->trace->as_string, "\n";}
my $e;
if ( $e = Exception::Class->caught('MyException') ) {
  print "General\n",$e->error, "\n";
} elsif ( $e = Exception::Class->caught('ExceptionTimeout')) {
  print "Timeout\n",$e->error, "\n";
}
print "Done.\n";
