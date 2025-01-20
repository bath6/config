{pkgs-unstable, ...}
: {
  hardware.amdgpu.opencl.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
    package = pkgs-unstable.ollama-rocm;
    host = "[::]";
    environmentVariables = {
      #      OLLAMA_LLM_LIBRARY = "rocm";
    };
  };
}
