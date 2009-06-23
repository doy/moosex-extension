package MooseX::Extension;
use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use Data::OptList qw(mkopt_hash);

my ($unimport, $args);

sub import {
    my $caller = caller;
    shift;
    $args = mkopt_hash(\@_);
    my @also = grep { !defined $args->{$_} && delete $args->{$_} } keys %$args;
    my $import;
    ($import, $unimport) = Moose::Exporter->build_import_methods(
        also => \@also,
    );
    goto $import;
}

sub unimport {
    goto $unimport;
}


sub init_meta {
    shift;
    my %options = @_;
    Moose->init_meta(%options);
    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class => $options{for_class},
    );
    Moose::Util::MetaRole::apply_base_class_roles(
        for_class => $options{for_class},
    );
    return Class::MOP::class_of($options{for_class});
}

1;
