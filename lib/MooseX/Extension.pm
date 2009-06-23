package MooseX::Extension;
use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;

my ($import, $unimport);

sub import {
    my $caller = caller;
    ($import, $unimport) = Moose::Exporter->build_import_methods;
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
