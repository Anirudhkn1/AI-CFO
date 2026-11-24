#!/usr/bin/perl
# Tiny local web server for the Obsid-finance demo (macOS ships with perl; nothing to install).
# Listens on 127.0.0.1 only, so it is reachable from this computer and nowhere else.
# usage: server.pl <app-folder> [first-port]
use strict;
use warnings;
use IO::Socket::INET;
use Cwd qw(abs_path);

my ($root_arg, $start) = @ARGV;
my $root = defined $root_arg ? abs_path($root_arg) : undef;
die "App folder not found.\n" unless $root && -f "$root/index.html";
$start ||= 8765;

my %mime = (
  html => 'text/html; charset=utf-8', js => 'text/javascript; charset=utf-8',
  mjs => 'text/javascript; charset=utf-8', css => 'text/css; charset=utf-8',
  json => 'application/json', map => 'application/json', wasm => 'application/wasm',
  png => 'image/png', jpg => 'image/jpeg', jpeg => 'image/jpeg', gif => 'image/gif',
  svg => 'image/svg+xml', ico => 'image/x-icon', webp => 'image/webp',
  otf => 'font/otf', ttf => 'font/ttf', woff => 'font/woff', woff2 => 'font/woff2',
  txt => 'text/plain; charset=utf-8', symbols => 'text/plain; charset=utf-8',
  bin => 'application/octet-stream',
);

my ($srv, $port);
for my $p ($start .. $start + 20) {
  $srv = IO::Socket::INET->new(
    LocalAddr => '127.0.0.1', LocalPort => $p, Proto => 'tcp',
    Listen => 64, ReuseAddr => 1,
  );
  if ($srv) { $port = $p; last; }
}
die "Could not find a free port between $start and " . ($start + 20) . ".\n" unless $srv;

my $url = "http://127.0.0.1:$port/";
$| = 1;
print "Obsid-finance is running at $url\n";
print "Leave this window open while you look around. Close it (or press Ctrl+C) to stop.\n";
if ($^O eq 'darwin' && !$ENV{OBSID_NO_OPEN}) { system('open', $url); }

$SIG{CHLD} = 'IGNORE';
while (my $c = $srv->accept) {
  my $pid = fork();
  if (!defined $pid) { handle($c); close $c; next; }   # fork failed: serve inline
  if ($pid == 0) { close $srv; handle($c); close $c; exit 0; }
  close $c;
}

sub handle {
  my ($c) = @_;
  binmode $c;
  $c->autoflush(1);
  local $SIG{ALRM} = sub { exit 0 };
  alarm 15;                                    # drop idle/speculative connections
  my $req = <$c>;
  return unless defined $req;
  while (my $l = <$c>) { last if $l =~ /^\r?\n$/; }
  alarm 0;

  my ($method, $target) = $req =~ m{^([A-Z]+)\s+(\S+)};
  return respond($c, 400, 'text/plain', "Bad request\n") unless $method && defined $target;
  return respond($c, 405, 'text/plain', "Method not allowed\n") unless $method eq 'GET' || $method eq 'HEAD';

  my $path = $target;
  $path =~ s/[?#].*$//;
  $path =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
  return respond($c, 403, 'text/plain', "Forbidden\n") if $path =~ /\0/ || $path =~ m{(^|/)\.\.(/|$)};
  $path =~ s{^/+}{};
  $path = 'index.html' if $path eq '' || $path =~ m{/$};

  my $file = abs_path("$root/$path");
  $file = abs_path("$file/index.html") if $file && -d $file;
  unless ($file && -f $file && index($file, $root) == 0) {
    return respond($c, 404, 'text/plain', "Not found\n", $method eq 'HEAD');
  }
  my ($ext) = $file =~ /\.([A-Za-z0-9]+)$/;
  my $type = $mime{ lc($ext // '') } // 'application/octet-stream';
  my $size = -s $file;
  open(my $fh, '<:raw', $file) or return respond($c, 500, 'text/plain', "Cannot read file\n");
  print $c "HTTP/1.1 200 OK\r\nContent-Type: $type\r\nContent-Length: $size\r\n"
         . "Cache-Control: no-cache\r\nConnection: close\r\n\r\n";
  if ($method eq 'GET') {
    my $buf;
    while (read($fh, $buf, 65536)) { print $c $buf or last; }
  }
  close $fh;
}

sub respond {
  my ($c, $code, $type, $body, $head) = @_;
  my %text = (200 => 'OK', 400 => 'Bad Request', 403 => 'Forbidden', 404 => 'Not Found',
              405 => 'Method Not Allowed', 500 => 'Internal Server Error');
  print $c "HTTP/1.1 $code $text{$code}\r\nContent-Type: $type\r\nContent-Length: " . length($body)
         . "\r\nConnection: close\r\n\r\n";
  print $c $body unless $head;
}
