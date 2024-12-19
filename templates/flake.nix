{
  description = "Flake templates!";

  outputs = {self}: {
    templates.c = {
      path = ./c;
      description = "Basic environment for C";
    };

    templates.default = self.templates.c;
  };
}
