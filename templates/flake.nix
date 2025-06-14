{
  description = "Flake templates!";

  outputs = {self}: {
    templates.c = {
      path = ./c;
      description = "Basic environment for C";
    };
    templates.plaformio = {
      path = ./platformio;
      description = "Basic environment for PlatformIO";
    };
    templates.python = {
      path = ./python;
      description = "Basic environment for Python";
    };

    templates.default = self.templates.c;
  };
}
