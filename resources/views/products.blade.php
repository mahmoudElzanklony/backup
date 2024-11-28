<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="{{ asset('css/style.css')  }}">
    <title>products</title>
</head>
<body>
    <form action="{{  route('employee.create')  }}"></form>
    <h1>welcome</h1>
    <h2>{{ $name  }}</h2>
    <img src="{{ asset('images/halls/1714865269782353060868_image.jpg') }}">
</body>
</html>
