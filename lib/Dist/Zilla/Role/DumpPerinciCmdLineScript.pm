package Dist::Zilla::Role::DumpPerinciCmdLineScript;

# DATE
# VERSION

use 5.010001;
use Moose::Role;

use Data::Dmp;
use Perinci::CmdLine::Dump;

sub dump_perinci_cmdline_script {
    my ($self, $file) = @_;

    my $filename = $file->name;

    # if file object is not a real file on the filesystem, put it in a temporary
    # file first so Perinci::CmdLine::Dump can see it.
    unless ($file->isa("Dist::Zilla::File::OnDisk")) {
        require File::Temp;
        my ($fh, $tempname) = File::Temp::tempfile();
        print $fh $file->content;
        close $fh;
        $filename = $tempname;
    }

    # so scripts can know that they are being dumped in the context of
    # Dist::Zilla
    local $ENV{DZIL} = 1;

    $self->log_debug(["Dumping Perinci::CmdLine script '%s'", $filename]);

    my $res = Perinci::CmdLine::Dump::dump_perinci_cmdline_script(
        filename => $filename,
        libs => ['lib'],
    );

    $self->log_debug(["Dump result: %s", dmp($res)]);
    $res;
}

no Moose::Role;
1;
# ABSTRACT: Role to dump Perinci::CmdLine script

=head1 METHODS

=head2 $obj->dump_perinci_cmdline_script($file)


=head1 SEE ALSO

L<Pod::Weaver::Role::DumpPerinciCmdLineScript> basically does the same thing,
but it accepts a slightly different argument (C<$input> instead of C<$file>).
