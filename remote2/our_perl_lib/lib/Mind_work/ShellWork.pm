package ShellWork;

use warnings;
use strict;

use Expect;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Mind_work::Mind_Common;

### we need: host, user, pass (if user is empty, it means that we use a publickey. Pass may be missing too in this case)
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
# 	connect_from => 'an already defined host from where we can connect (default is local)',
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
# Mind_Common::hash_to_xmlfile (\%machine1, "machine.xml");
# print Dumper(Mind_Common::xmlfile_to_hash("machine.xml"));
# exit 1;

my ($timeout, $prompt, $user, $pass, $host, $go_from_prompt);
my $max_wait_timeout = 60;
my $max_running_timeout = 300;
my $exp;
my $machine;

sub new {
    my $class = shift;
    my $self = { expect => shift};
    $exp = $self->{expect};
    $exp->log_stdout(0);
    $exp->debug(0);
    $exp->raw_pty(1);
    bless($self, $class);
    return $self;
}

sub update_machine {
  my $self = shift;
  ($machine, $go_from_prompt) = @_;
  $host = $machine->{'connection'}->{'host'};
  $pass = $machine->{'connection'}->{'pass'};
  $user = $machine->{'connection'}->{'user'};
  $prompt = $machine->{'connection'}->{'prompt'} || Mind_Common::generate_random_string(6);
  $timeout = $machine->{'connection'}->{'timeout'} || 5;
}

sub verify_prompt {
  my $self = shift;
  $exp->send("\n");
  my $ret = $exp->expect($timeout, $prompt);
  MyException->throw( error => "Could not check prompt.\n") if ! defined $ret;
}

sub new_bash_prompt {
  my $self = shift;
  my $new_prompt = "mind_".Mind_Common::generate_random_string(6)."_ ";
  $exp->send("export PS1=\"$new_prompt\";export PROMPT_COMMAND=\"\"\n");
  my $ret = $exp->expect($timeout, $new_prompt);
  $ret = $exp->expect($timeout, $new_prompt);
  MyException->throw( error => "Could not set prompt.\n") if ! defined $ret;
  $prompt = $new_prompt;
  print "New prompt set to $prompt.\n";
  verify_prompt;
}

sub login_ssh {
  my $self = shift;
  my $cmd = "ssh $user\@$host -t bash";
  $cmd .= " --noprofile --norc" if ! defined $machine->{'connection'}->{'load_profile'} || $machine->{'connection'}->{'load_profile'} =~ m/^no$/i;
  $exp->send("$cmd\n");
  my $ok;
  my $extra_pos = 0;
  my $extra = $machine->{'connection'}->{'extra'}[$extra_pos++];
  my ($extra_question, $extra_annswer) = ($extra->{'question'}, $extra->{'answer'});
  $extra_question = Mind_Common::generate_random_string(200) if ! defined $extra_question;

  my $ret = $exp->expect(
	      $timeout,
              [quotemeta $prompt,
                sub {$ok = 1; print "Logged in.\n";}
	       ],
              [ qr/Are you sure you want to continue connecting ?\(yes\/no\)\? ?/,
                sub {$exp->send("yes\n"); exp_continue;}
               ],
              [ quotemeta "$extra_question",
                sub {
		  $ok = 1; $exp->send("$extra_annswer\n");
		  $extra = $machine->{'connection'}->{'extra'}[$extra_pos++];
		  ($extra_question, $extra_annswer) = ($extra->{'question'}, $extra->{'answer'});
		  $extra_question = Mind_Common::generate_random_string(200) if ! defined $extra_question;
		  exp_continue;
		}
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
              [ timeout =>
                sub {
                  MyException->throw( error => "ERROR: timeout trying to open ssh.\n");
                }
               ],
              );
  $prompt = guess_promp($self) if ! defined $ret || ! $ok;
  MyException->throw( error => "ERROR: could not login.Seems we have the same prompt\n") if $go_from_prompt eq $prompt;
  new_bash_prompt;
  return $prompt;
}

sub logout_ssh {
  my $self = shift;
  $prompt = shift;
  $exp->send("exit\n");
  my $ret = $exp->expect(
	      $timeout,
              [quotemeta $prompt],
              [ eof =>
                sub {MyException->throw( error => "ERROR: eof could not exit.\n");}
               ],
              [ timeout =>
                sub {
		  ExceptionTimeout->throw( error => "ERROR: timeout trying to exit.\n");
		}
               ],
              );
}

sub guess_promp {
  my $self = shift;
  print "Try to guess prompt.\n";
  my ($prompt1, $prompt2) = "";
  my $retries = 0;
  $prompt1 = $exp->before();
  $exp->clear_accum();

  while ($retries < 10 ) {
    $exp->send("\n");
    $exp->expect($timeout);
    $prompt2 = $exp->before();
    $prompt2 =~ s/^\s*\r\n//smg;
    print "\n".Dumper (quotemeta $prompt1, quotemeta $prompt2);
    if (quotemeta $prompt1 eq quotemeta $prompt2 && $prompt1 !~ m/^\s*$/) {
      $prompt = $prompt1;
      print "Found prompt: $prompt.\n";
      $machine->{'connection'}->{'prompt'} = $prompt;
      $exp->clear_accum();
      return $prompt;
    }
    $prompt1 = $prompt2;
    $exp->clear_accum();
  }

  MyException->throw( error => 'Could not find prompt.\n' );
}

sub exec_shell_command {
  my $self = shift;
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
  my $res = $exp->before;
  $cmd = quotemeta $cmd;
  $res =~ s/^$cmd\r\n//ms;
  $exp->send('echo $?'."\n");
  $ret = $exp->expect(
	      $timeout,
              [quotemeta $prompt
	       ],
              [ eof =>
                sub {MyException->throw( error => "ERROR: EOF trying to get the exit status.\n");}
               ],
              [ timeout =>
		sub {MyException->throw( error => "ERROR: Timeout trying to get the exit status.\n");}
               ],
              );
  my $result = $exp->before;
  $result =~ s/^echo \$\?\r\n([0-9]+)\r\n$/$1/ms;
  MyException->throw( error => "ERROR: Command returned status error.\n") if $result > 0;
  return $res;
}

1;
