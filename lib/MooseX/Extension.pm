package MooseX::Extension;
use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use Data::OptList qw(mkopt_hash);

my ($unimport, $on_unimport, $args);

sub import {
    my $caller = caller;
    shift;
    $args = mkopt_hash(\@_);
    my @also = grep { !defined $args->{$_} && delete $args->{$_} } keys %$args;
    my $import;
    ($import, $unimport) = Moose::Exporter->build_import_methods(
        also => \@also,
    );
    $args->{-on_import}->($caller) if defined $args->{-on_import};
    $on_unimport = delete $args->{-on_unimport};
    goto $import;
}

sub unimport {
    my $caller = caller;
    $on_unimport->($caller) if defined $on_unimport;
    goto $unimport;
}


sub init_meta {
    shift;
    my %options = @_;
    Moose->init_meta(%options);
    my $base_class_roles = delete $args->{-base_class_roles};
    my %metaclass_roles = map {
        my $key = $_;
        $key =~ s/^-//;
        ($key, $args->{-$key});
    } keys %$args;
    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class => $options{for_class},
    );
    Moose::Util::MetaRole::apply_base_class_roles(
        for_class => $options{for_class},
    );
    return Class::MOP::class_of($options{for_class});
}

1;
