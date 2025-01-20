{pkgs-ollama, ...}
: {
  hardware.amdgpu.opencl.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.1.0";
    package = pkgs-ollama.ollama-rocm;
    host = "[::]";
    environmentVariables = {
      #      OLLAMA_LLM_LIBRARY = "rocm";
    };
  };
}
