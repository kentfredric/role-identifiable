package Role::Identifiable::HasIdent;

use Moo::Role;
# ABSTRACT: a thing with an ident attribute

=head1 DESCRIPTION

This is an incredibly simple role.  It adds a required C<ident> attribute that
stores a simple string, meant to identify exceptions.

The string has to contain at least one character, and it can't start or end
with whitespace.

=cut

has ident => (
  is       => 'ro',
  required => 1,
  isa      => sub {
    # Apropos of type Str with { length && /\A\S/ && /\S\z/ }
    # extracted from Types::Standard -- kentnl 2015-02-18
    die 'ident must be a string'
        unless defined $_[0] and do { ref $_[0] eq 'SCALAR' or ref (\(my $val = $_[0])) eq 'SCALAR' };
    die 'ident must have non-zero length'
        unless length $_[0];
    die 'ident must not start or end with whitespace'
        unless $_[0] =~/\A\S/ && $_[0] =~ /\S\z/;
  },
);

no Moo::Role;
1;
