package Error::Tiny::Exception;

use strict;
use warnings;

require Carp;

use overload '""' => \&to_string, fallback => 1;

sub new {
    my $class = shift;
    my (%params) = @_;

    my $self = {};
    bless $self, $class;

    $self->{message} = $params{message};
    $self->{file}    = $params{file};
    $self->{line}    = $params{line};

    return $self;
}

sub message { $_[0]->{message} }
sub line    { $_[0]->{line} }
sub file    { $_[0]->{file} }

sub throw {
    my $class = shift;
    my ($message) = @_;

    my (undef, $file, $line) = caller(0);
    my $self = $class->new(message => $message, file => $file, line => $line);

    Carp::croak($self);
}

sub rethrow {
    my $self = shift;

    Carp::croak($self);
}

sub catch {
    my $self = shift;
    my ($with, @tail) = @_;

    my $class = ref($self) ? ref($self) : $self;
    (Error::Tiny::Catch->new(handler => $with->handler, class => $class),
        @tail);
}

sub to_string { "$_[0]->{message} $_[0]->{file} at $_[0]->{line}." }

1;
