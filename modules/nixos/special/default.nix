{ hostname
, ...
}:
{
  imports = [
    ./${hostname}
  ];
}