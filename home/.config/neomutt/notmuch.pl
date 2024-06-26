#!/usr/bin/env perl
#
# notmuch-mutt - notmuch (of a) helper for Mutt
#
# Copyright: Â© 2011-2015 Stefano Zacchiroli <zack@upsilon.cc>
# License: GNU General Public License (GPL), version 3 or above
#
# See the bottom of this file for more documentation.
# A manpage can be obtained by running "pod2man notmuch-mutt > notmuch-mutt.1"

use strict;
use warnings;

use File::Path;
use File::Basename;
use File::Find;
use Getopt::Long qw(:config no_getopt_compat);
use Mail::Header;
use Mail::Box::Maildir;
use Pod::Usage;
use Term::ReadLine;
use Digest::SHA;


my $xdg_cache_dir = "$ENV{HOME}/.cache";
$xdg_cache_dir = $ENV{XDG_CACHE_HOME} if $ENV{XDG_CACHE_HOME};
my $cache_dir = "$xdg_cache_dir/notmuch/mutt";

sub die_dir($$) {
    my ($maildir, $error) = @_;
    die "notmuch-mutt: search cache maildir $maildir $error\n".
        "Please ensure that the notmuch-mutt search cache Maildir\n".
        "contains no subfolders or real mail data, only symlinks to mail\n";
}

sub die_subdir($$$) {
    my ($maildir, $subdir, $error) = @_;
    die_dir($maildir, "subdir $subdir $error");
}

# check that the search cache maildir is that and not a real maildir
# otherwise there could be data loss when the search cache is emptied
sub check_search_cache_maildir($) {
    my ($maildir) = (@_);

    return unless -e $maildir;

    -d $maildir or die_dir($maildir, 'is not a directory');

    opendir(my $mdh, $maildir) or die_dir($maildir, "cannot be opened: $!");
    my @contents = grep { !/^\.\.?$/ } readdir $mdh;
    closedir $mdh;

    my @required = ('cur', 'new', 'tmp');
    foreach my $d (@required) {
        -l "$maildir/$d" and die_dir($maildir, "contains symlink $d");
        -e "$maildir/$d" or die_subdir($maildir, $d, 'is missing');
        -d "$maildir/$d" or die_subdir($maildir, $d, 'is not a directory');
        find(sub {
            $_ eq '.' and return;
            $_ eq '..' and return;
            -l $_ or die_subdir($maildir, $d, "contains non-symlink $_");
        }, "$maildir/$d");
    }

    my %required = map { $_ => 1 } @required;
    foreach my $d (@contents) {
        -l "$maildir/$d" and die_dir( $maildir, "contains symlink $d");
        -d "$maildir/$d" or die_dir( $maildir, "contains non-directory $d");
        exists($required[$d]) or die_dir( $maildir, "contains directory $d");
    }
}

# create an empty search cache maildir (if missing) or empty existing one
sub empty_search_cache_maildir($) {
    my ($maildir) = (@_);
    rmtree($maildir) if (-d $maildir);
    my $folder = new Mail::Box::Maildir(folder => $maildir,
					create => 1);
    $folder->close();
}

# search($maildir, $remove_dups, $query)
# search mails according to $query with notmuch; store results in $maildir
sub search($$$) {
    my ($maildir, $remove_dups, $query) = @_;
    my $dup_option = "";

    my @args = qw/notmuch search --output=files/;
    push @args, "--duplicate=1" if $remove_dups;
    push @args, $query;

    check_search_cache_maildir($maildir);
    empty_search_cache_maildir($maildir);
    open my $pipe, '-|', @args or die "Running @args failed: $!\n";
    while (<$pipe>) {
	chomp;
	my $ln = "$maildir/cur/" . basename $_;
	symlink $_, "$ln" or warn "Failed to symlink '$_', '$ln': $!\n";
    }
}

sub prompt($$) {
    my ($text, $default) = @_;
    my $query = "";
    my $term = Term::ReadLine->new( "notmuch-mutt" );
    my $histfile = "$cache_dir/history";

    $term->ornaments( 0 );
    $term->unbind_key( ord( "\t" ) );
    $term->MinLine( 3 );
    $histfile = $ENV{MUTT_NOTMUCH_HISTFILE} if $ENV{MUTT_NOTMUCH_HISTFILE};
    $term->ReadHistory($histfile) if (-r $histfile);
    while (1) {
	chomp($query = $term->readline($text, $default));
	if ($query eq "?") {
	    system("man", "notmuch-search-terms");
	} else {
	    $term->WriteHistory($histfile);
	    return $query;
	}
    }
}

sub get_message_id() {
    my $mid = undef;
    my @headers = ();

    while (<STDIN>) {  # collect header lines in @headers
	push(@headers, $_);
	last if $_ =~ /^$/;
    }
    my $head = Mail::Header->new(\@headers);
    $mid = $head->get("message-id") or undef;

    if ($mid) {  # Message-ID header found
	$mid =~ /^<(.*)>$/;  # extract message id
	$mid = $1;
    } else {  # Message-ID header not found, synthesize a message id
	      # based on SHA1, as notmuch would do.  See:
	      # https://git.notmuchmail.org/git/notmuch/blob/HEAD:/lib/sha1.c
	my $sha = Digest::SHA->new(1);
	$sha->add($_) foreach(@headers);
	$sha->addfile(\*STDIN);
	$mid = 'notmuch-sha1-' . $sha->hexdigest;
    }

    return $mid;
}

sub search_action($$$@) {
    my ($interactive, $results_dir, $remove_dups, @params) = @_;

    if (! $interactive) {
	search($results_dir, $remove_dups, join(' ', @params));
    } else {
	my $query = prompt("search ('?' for man): ", join(' ', @params));
	if ($query ne "") {
	    search($results_dir, $remove_dups, $query);
	}
    }
}

sub thread_action($$@) {
    my ($results_dir, $remove_dups, @params) = @_;

    my $mid = get_message_id();
    if (! defined $mid) {
	die "notmuch-mutt: cannot find Message-Id, abort.\n";
    }

    $mid =~ s/ //g; # notmuch strips spaces before storing Message-Id
    $mid =~ s/"/""""/g; # escape all double quote characters twice

    search($results_dir, $remove_dups, qq{thread:"{id:""$mid""}"});
}

sub tag_action(@) {
    my $mid = get_message_id();
    defined $mid or die "notmuch-mutt: cannot find Message-Id, abort.\n";

    $mid =~ s/ //g; # notmuch strips spaces before storing Message-Id
    $mid =~ s/"/""/g; # escape all double quote characters

    system("notmuch", "tag", @_, "--", qq{id:"$mid"});
}

sub die_usage() {
    my %podflags = ( "verbose" => 1,
		    "exitval" => 2 );
    pod2usage(%podflags);
}

sub main() {
    mkpath($cache_dir) unless (-d $cache_dir);

    my $results_dir = "$cache_dir/results";
    my $interactive = 0;
    my $help_needed = 0;
    my $remove_dups = 0;

    my $getopt = GetOptions(
	"h|help" => \$help_needed,
	"o|output-dir=s" => \$results_dir,
	"p|prompt" => \$interactive,
	"r|remove-dups" => \$remove_dups);
    if (! $getopt || $#ARGV < 0) { die_usage() };
    my ($action, @params) = ($ARGV[0], @ARGV[1..$#ARGV]);

    foreach my $param (@params) {
      $param =~ s/folder:=/folder:/g;
    }

    if ($help_needed) {
	die_usage();
    } elsif ($action eq "search" && $#ARGV == 0 && ! $interactive) {
	print STDERR "Error: no search term provided\n\n";
	die_usage();
    } elsif ($action eq "search") {
	search_action($interactive, $results_dir, $remove_dups, @params);
    } elsif ($action eq "thread") {
	thread_action($results_dir, $remove_dups, @params);
    } elsif ($action eq "tag") {
	tag_action(@params);
    } else {
	die_usage();
    }
}

main();

__END__

=head1 NAME

notmuch-mutt - notmuch (of a) helper for Mutt

=head1 SYNOPSIS

=over

=item B<notmuch-mutt> [I<OPTION>]... search [I<SEARCH-TERM>]...

=item B<notmuch-mutt> [I<OPTION>]... thread < I<MAIL>

=item B<notmuch-mutt> [I<OPTION>]... tag [I<TAGS>]... < I<MAIL>

=back

=head1 DESCRIPTION

notmuch-mutt is a frontend to the notmuch mail indexer capable of populating
a maildir with search results.

=head1 OPTIONS

=over 4

=item -o DIR

=item --output-dir DIR

Store search results as (symlink) messages under maildir DIR. Beware: DIR will
be overwritten. (Default: F<~/.cache/notmuch/mutt/results/>)

=item -p

=item --prompt

Instead of using command line search terms, prompt the user for them (only for
"search").

=item -r

=item --remove-dups

Remove emails with duplicate message-ids from search results.  (Passes
--duplicate=1 to notmuch search command.)  Note this can hide search
results if an email accidentally or maliciously uses the same message-id
as a different email.

=item -h

=item --help

Show usage information and exit.

=back

=head1 INTEGRATION WITH MUTT

notmuch-mutt can be used to integrate notmuch with the Mutt mail user agent
(unsurprisingly, given the name). To that end, you should define macros like
the following in your Mutt configuration (usually one of: F<~/.muttrc>,
F</etc/Muttrc>, or a configuration snippet under F</etc/Muttrc.d/>):

    macro index <F8> \
    "<enter-command>set my_old_pipe_decode=\$pipe_decode my_old_wait_key=\$wait_key nopipe_decode nowait_key<enter>\
    <shell-escape>notmuch-mutt -r --prompt search<enter>\
    <change-folder-readonly>`echo ${XDG_CACHE_HOME:-$HOME/.cache}/notmuch/mutt/results`<enter>\
    <enter-command>set pipe_decode=\$my_old_pipe_decode wait_key=\$my_old_wait_key<enter>" \
          "notmuch: search mail"

    macro index <F9> \
    "<enter-command>set my_old_pipe_decode=\$pipe_decode my_old_wait_key=\$wait_key nopipe_decode nowait_key<enter>\
    <pipe-message>notmuch-mutt -r thread<enter>\
    <change-folder-readonly>`echo ${XDG_CACHE_HOME:-$HOME/.cache}/notmuch/mutt/results`<enter>\
    <enter-command>set pipe_decode=\$my_old_pipe_decode wait_key=\$my_old_wait_key<enter>" \
          "notmuch: reconstruct thread"

    macro index <F6> \
    "<enter-command>set my_old_pipe_decode=\$pipe_decode my_old_wait_key=\$wait_key nopipe_decode nowait_key<enter>\
    <pipe-message>notmuch-mutt tag -- -inbox<enter>\
    <enter-command>set pipe_decode=\$my_old_pipe_decode wait_key=\$my_old_wait_key<enter>" \
          "notmuch: remove message from inbox"

The first macro (activated by <F8>) prompts the user for notmuch search terms
and then jump to a temporary maildir showing search results. The second macro
(activated by <F9>) reconstructs the thread corresponding to the current mail
and show it as search results. The third macro (activated by <F6>) removes the
tag C<inbox> from the current message; by changing C<-inbox> this macro may be
customised to add or remove tags appropriate to the users notmuch work-flow.

To keep notmuch index current you should then periodically run C<notmuch
new>. Depending on your local mail setup, you might want to do that via cron,
as a hook triggered by mail retrieval, etc.

=head1 SEE ALSO

mutt(1), notmuch(1)

=head1 AUTHOR

Copyright: (C) 2011-2012 Stefano Zacchiroli <zack@upsilon.cc>

License: GNU General Public License (GPL), version 3 or higher

=cut
