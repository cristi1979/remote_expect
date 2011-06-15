#!/usr/bin/perl
use warnings;
use strict;

$SIG{__WARN__} = sub { die @_ };

use Cwd 'abs_path','chdir';
use File::Basename;

### Windows:
# putty test@10.0.0.232 -pw test1234 -m d:/run_commands

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

use Expect;
$Expect::Multiline_Matching = 1;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
# $Expect::Debug = 1;
use Mind_work::ShellWork;

my $exp = new Expect;
my $ssh = new ShellWork($exp);
my $timeout = 2;
# my $prompt;
my @prompts = ();

use Exception::Class (
  'MyException' => {
	description => 'General'
    },
  'ExceptionTimeout' => {
	isa => 'MyException',
	description => 'timeout'
    }
);

sub start_local_bash {
  my $prompt = shift;
  $exp->spawn("bash") or MyException->throw( error => "Cannot spawn bash: $!\n");
  my $ret = $exp->expect($timeout, $prompt);
  $prompt = $ssh->guess_promp() if ! defined $ret;
  return $prompt;
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

$exp->log_stdout(1);
my $machines_path = "$script_dir/networks";

my %machine = (
    connection => {
	pass => "test1234",
	user => "test",
	host => "10.0.0.232",
	prompt => 'bash-2.05$ ',
    }
  );
my %wiki = (
    connection => {
	pass => "cristi",
	user => "cristi",
	host => "10.0.0.99",
	prompt => '[cristi@localhost ~]$ ',
	connect_from => '10.0.0.232',
	load_profile => 'yes',
    }
  );
my %qw = (
    connection => {
	pass => '!0root@9',
	user => "root",
	host => "10.0.0.199",
	prompt => 'bash-4.2# ',
	connect_from => '10.0.0.99',
	load_profile => 'no',
    }
  );
my $all_machines = {};
foreach my $machine (\%machine, \%wiki) {
  $all_machines->{$machine->{'connection'}->{'host'}} = $machine;
}



eval {

my $prompt = '[wiki@localhost remote2]$ ';
my $me->{'connection'}->{'prompt'} = $prompt;
$me->{'connection'}->{'timeout'} = 2;
$ssh->update_machine($me);
$prompt = start_local_bash($prompt);

foreach my $host (keys %$all_machines) {
  push @prompts, $prompt;
  my @login_path = ();
  my $done = 0;
  while (! $done) {
    my $machine = $all_machines->{$host};
    $machine->{'connection'}->{'connect_from'} = 'local' if defined $machine && ! defined $machine->{'connection'}->{'connect_from'};
    push @login_path, $machine;
    if (! defined $machine ) {
      print "We don't have a definition for host $host.\n";
      @login_path = ();
      $done++;
      next;
    }
    $done++ if $machine->{'connection'}->{'connect_from'} eq 'local';
    $host = $machine->{'connection'}->{'connect_from'};
  }
  while (@login_path) {
    my $machine = pop @login_path;
    $ssh->update_machine($machine, $prompts[scalar @prompts - 1]);
    push @prompts, $ssh->login_ssh;
  }
  my $res = $ssh->exec_shell_command("ls /");
  $res = $ssh->exec_shell_command("echo XXXXXXXXXXXXXXXXXXXXXXXXX");
print "________________________\n".$res."________________________\n";
  $res = $ssh->exec_shell_command("echo 100+200|bc");
print "________________________\n".$res."________________________\n";
  $res = $ssh->exec_shell_command("cat /nuexista");
print "________________________\n".$res."________________________\n";
  pop @prompts;
  while (@prompts) {
     $ssh->logout_ssh(pop @prompts);
  }
}

stop_local_bash;
$exp->soft_close();

};

my $e;
if ( $e = Exception::Class->caught('MyException') ) {
  print "General\n",$e->error, "\n";
} elsif ( $e = Exception::Class->caught('ExceptionTimeout')) {
  print "Timeout\n",$e->error, "\n";
} else {
  $e = Exception::Class->caught();
  ref $e ? $e->rethrow : print $e;
}
print "Done.\n";
