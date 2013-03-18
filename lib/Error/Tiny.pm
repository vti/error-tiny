package Error::Tiny;

use strict;
use warnings;

use vars qw(@ISA @EXPORT @EXPORT_OK);

BEGIN {
    require Exporter;
    @ISA = qw(Exporter);
}

@EXPORT = @EXPORT_OK = qw(try with catch);

require Carp;
$Carp::Internal{+__PACKAGE__}++;

require Scalar::Util;

use Error::Tiny::Exception;
use Error::Tiny::Catch;
use Error::Tiny::With;

sub try(&;@) {
    my ($try, @handlers) = @_;

    my $wantarray = wantarray;

    local $@;
    my @ret;
    eval { @ret = $wantarray ? $try->() : scalar $try->(); 1 } || do {
        my $e      = $@;
        my $orig_e = $e;

        if (!Scalar::Util::blessed($e)) {
            $orig_e =~ s{ at ([\S]+) line (\d+)\.\s*$}{}ms;
            $e = Error::Tiny::Exception->new(
                message => $orig_e,
                file    => $1,
                line    => $2
            );
        }

        for my $handler (@handlers) {
            if ($handler->isa('Error::Tiny::Catch')) {
                if ($e->isa($handler->class)) {
                    return $handler->handler->($e);
                }
            }
        }

        Carp::croak($orig_e);
    };

    return $wantarray ? @ret : $ret[0];
}

sub catch(&;@) {
    my ($class, $handler) =
      @_ == 2 ? ($_[0], $_[1]->handler) : ('Error::Tiny::Exception', $_[0]);

    Error::Tiny::Catch->new(handler => $handler, class => $class);
}

sub with(&;@) {
    my ($handler, $subhandler) = @_;

    (Error::Tiny::With->new(handler => $handler), $subhandler);
}

1;
