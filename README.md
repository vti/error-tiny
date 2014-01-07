# NAME

Error::Tiny - Tiny exceptions

# SYNOPSIS

    use Error::Tiny;

    try {
        dangerous();
    }
    catch MyCustomException then {
        my $e = shift;

        ...everything whose parent is MyCustomException...
    }
    catch {
        my $e = shift;

        ...everything else goes here...
    };

# DESCRIPTION

[Error::Tiny](http://search.cpan.org/perldoc?Error::Tiny) is a lightweight exceptions implementation.

# FEATURES

## `Objects everywhere`

You will always get an object in the catch block. No need to check if it's
a blessed reference or anything like that. And there is no need for
`$SIG{__DIE__}`!

## `Exception class built-in`

[Error::Tiny::Exception](http://search.cpan.org/perldoc?Error::Tiny::Exception) is a lightweight base exception class. It is easy to
throw an exception:

    Error::Tiny::Exception->throw('error');

# DEVELOPMENT

## Repository

    http://github.com/vti/error-tiny

# AUTHOR

Viacheslav Tykhanovskyi, `vti@cpan.org`.

# COPYRIGHT AND LICENSE

Copyright (C) 2013, Viacheslav Tykhanovskyi

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.
