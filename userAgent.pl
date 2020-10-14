#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use HTTP::BrowserDetect;

get '/' => sub {
  my $self   = shift;
  # используем модуль из CPAN для определения юзео агента
  my $browser = new HTTP::BrowserDetect($self->req->headers->user_agent);
  # подготовливаем данные для вывода
  my $data = {'IP' => $self->tx->remote_address,
        'OS' => $browser->os_string,
        'browser' => $browser->browser_string};
  # определяем вариант вывода и выводим данные
  $self->respond_to(
      json => {json => $data},
      any  => {template => 'browser', STR => $data}
  );
};

app->start;

__DATA__
# шаблон     
@@ browser.html.ep
<!doctype html>
<html>
    <head><title>Browser data</title></head>
    <body>
        IP address: <%= dumper $STR->{'IP'} %><br>
        OS: <%= dumper $STR->{'OS'} %><br>
        Browser: <%= dumper $STR->{'browser'} %><br>
    </body>
</html>
