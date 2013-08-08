package Role::Identifiable::HasTags;

use Type::Utils -all;
use Types::Standard qw(Str ArrayRef);
our $_Tag = declare 'Tag', as Str, where { length };


use Moo::Role;
# ABSTRACT: a thing with a list of tags

=head1 OVERVIEW

This role adds the ability for your class and its composed parts (roles,
superclasses) as well as instances of it to contribute to a pool of tags
describing each instance.

The behavior of this role is not yet very stable.  Do not rely on it yet.

=cut


sub has_tag {
  my ($self, $tag) = @_;

  $_ eq $tag && return 1 for $self->tags;

  return;
}

sub tags {
  my ($self) = @_;

  # Poor man's uniq:
  my %tags = map {; $_ => 1 }
             (@{ $self->_default_tags }, @{ $self->_instance_tags });

  return wantarray ? keys %tags : (keys %tags)[0];
}

has instance_tags => (
  is     => 'ro',
  isa    => ArrayRef[ $_Tag ],
  reader => '_instance_tags',
  init_arg => 'tags',
  default  => sub { [] },
);

has _default_tags => (
  is      => 'ro',
  builder => '_build_default_tags',
);

sub _build_default_tags {
  # This code stolen happily from Moose::Object::BUILDALL -- rjbs, 2010-10-18

  # NOTE: we ask Perl if we even need to do this first, to avoid extra meta
  # level calls
  return [] unless $_[0]->can('x_tags');

  my @tags;

  my ($self, $params) = @_;
  foreach my $method (
    reverse Class::MOP::class_of($self)->find_all_methods_by_name('x_tags')
  ) {
    push @tags, $method->{code}->execute($self, $params);
  }

  return \@tags;
}

no Moo::Role;
no Type::Utils;
no Types::Standard;

1;
