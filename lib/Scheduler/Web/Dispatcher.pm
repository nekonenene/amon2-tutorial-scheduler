package Scheduler::Web::Dispatcher;

use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterBoom;
use Data::Dumper;

any '/' => sub {
    my ($c) = @_;
    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);
    return $c->render('index.tx', {
        counter => $counter,
    });
};

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

# curl -X POST "http://127.0.0.1:8013/api/hello?name=Kanako"
post '/api/hello' => sub {
    my ($c) = @_;
    print Dumper($c->req->parameters);
    my $name = $c->req->parameters->{name};

    return $c->render_json(+{
        message => "Hello, $name!",
    });
};

1;
