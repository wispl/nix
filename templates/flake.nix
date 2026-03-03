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
    templates.embedded = {
      path = ./embedded;
      description = "Basic environment for doom and despair";
    };

    templates.default = self.templates.c;
  };
}
