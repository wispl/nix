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

    templates.default = self.templates.c;
  };
}
