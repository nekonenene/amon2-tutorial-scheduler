package Scheduler::Web::Dispatcher;

use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterBoom;
use Data::Dumper;
use Time::Piece;
use Log::Minimal;

any '/' => sub {
    my ($c) = @_;

    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);

    my @schedules = $c->db->search('schedules');

    return $c->render('index.tx', {
        counter => $counter,
        schedules => \@schedules,
    });
};

post '/post' => sub {
    my ($c) = @_;
    my $title = $c->req->parameters->{title};
    my $date = $c->req->parameters->{date};

    infof $date;

    if ($title eq '' || $date eq '') {
        return $c->redirect('/');
    }

    my $date_epoch = Time::Piece->strptime($date, '%Y-%m-%d')->epoch;

    infof $title;
    infof $date_epoch;

    $c->db->insert(schedules => {
        title => $title,
        date  => $date_epoch,
    });

    return $c->redirect('/');
};

post '/schedules/:id/delete' => sub {
    my ($c, $args) = @_;
    my $id = $args->{id};

    $c->db->delete(schedules => {
        id => $id,
    });

    return $c->redirect('/');
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
