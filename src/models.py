import os
import subprocess


PATH_TO_MOUNT = "/workspace"
PATH_TO_COMFY = "/app/src/ComfyUI"

class InstallModel:
    def __init__(self, namemodel, models, huggingface_token = ""):
        self.models = models
        self.namemode = namemodel
        self.huggingface_token = huggingface_token
        if huggingface_token == "":
            raise ValueError("Please provide a valid huggingface token")
    
        self.install_model()

    def install_model(self):
        print(f"Installing and config {self.namemode} models...")

        if not os.path.exists(PATH_TO_MOUNT):
            print("Mount file not found, direct download to good path")
            for model in self.models:
                print(f"---------- Installing {model["name"]} ----------")
                if not os.path.exists(model["path_comfy"]):
                    print("Downloading model...")
                    subprocess.run([
                        "wget",
                        "--header",
                        f"Authorization: Bearer {self.huggingface_token}",
                        model["URL"],
                        "-O",
                        model["name"]
                    ], cwd=PATH_TO_COMFY)
                else:
                    print(f"Model {model["name"]} already exist")
        else:
            for model in self.models:
                if not os.path.exists(model["path_comfy"]):
                    print(f"---------- Installing {model["name"]} ----------")
                    if not os.path.exists(model["path_mount"]):
                        print("Downloading model...")
                        subprocess.run([
                            "wget",
                            "--header",
                            f"Authorization: Bearer {self.huggingface_token}",
                            model["URL"],
                            "-O",
                            model["name"]
                        ], cwd=PATH_TO_MOUNT)
                    
                    print("copy file...")
                    subprocess.run([
                        "cp",
                        "-v",
                        model["path_mount"],
                        model["path_comfy"]
                    ])


if __name__ == "__main__":    
    # ------------------------ Description -------------------------
    #
    # Install and Config Flux 1 DEV models ( DoubleCLIP + VAE + DIFFUSERS MODEL )
    #
    # ------------------------ Description -------------------------
    FLUX_1_DEV = [
        {
            "name": "flux1-dev.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/flux1-dev.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/unet/flux1-dev.safetensors",
            "URL": "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"
        },
        {
            "name": "ae.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/ae.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/vae/ae.safetensors",
            "URL": "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors"
        },
        {
            "name": "clip_l.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/clip_l.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/clip/clip_l.safetensors",
            "URL": "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
        },
        {
            "name": "t5xxl_fp8_e4m3fn.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/t5xxl_fp8_e4m3fn.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/clip/t5xxl_fp8_e4m3fn.safetensors",
            "URL": "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"         
        },
        {
            "name": "t5xxl_fp16.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/t5xxl_fp16.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/clip/t5xxl_fp16.safetensors",
            "URL": "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"
        }
    ]

    # ------------------------ Description -------------------------
    #
    # Install and Config STABLE DIFFUSION 3.5 LARGE models ( TripCLIP + DIFFUSERS MODEL )
    #
    # ------------------------ Description -------------------------
    STABLE_DIFFUSION = [
        { 
            "name": "sd3.5_large.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/sd3.5_large.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/checkpoints/sd3.5_large.safetensors",
            "URL": "https://huggingface.co/stabilityai/stable-diffusion-3.5-large/resolve/main/sd3.5_large.safetensors"
        },
        {
            "name": "clip_l_sd.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/clip_l_sd.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/clip/clip_l_sd.safetensors",
            "URL": "https://huggingface.co/stabilityai/stable-diffusion-3.5-large/resolve/main/text_encoders/clip_l.safetensors"
        },
        {
            "name": "t5xxl.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/t5xxl.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/clip/t5xxl.safetensors",
            "URL": "https://huggingface.co/stabilityai/stable-diffusion-3.5-large/resolve/main/text_encoders/t5xxl_fp16.safetensors"
        },
        {
            "name": "clip_g_sd.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/clip_g_sd.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/clip/clip_g_sd.safetensors",
            "URL": "https://huggingface.co/stabilityai/stable-diffusion-3.5-large/resolve/main/text_encoders/clip_g.safetensors"
        }
    ]

    # ------------------------ Description -------------------------
    #
    # Install and Config LORA ULTRAREALIST models for Flux 1 DEV ( LoRA )
    #
    # ------------------------ Description -------------------------
    LORA_ULTRAREALIST = [
        {
            "name": "Canopus-LoRA-Flux-UltraRealism.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/Canopus-LoRA-Flux-UltraRealism.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/loras/Canopus-LoRA-Flux-UltraRealism.safetensors",
            "URL": "https://huggingface.co/prithivMLmods/Canopus-LoRA-Flux-UltraRealism-2.0/resolve/main/Canopus-LoRA-Flux-UltraRealism.safetensors"
        }
    ]

    # ------------------------ Description -------------------------
    # UNET
    # Install and Config FLUX 1 SCHELDD models ( DoubleCLIP + VAE + DIFFUSERS MODEL )
    #
    # ------------------------ Description -------------------------
    FLUX_1_SCHELDD_UNET = [
        {
            "name": "flux1-schnell.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/flux1-schnell.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/unet/flux1-schnell.safetensors",
            "URL" : "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors"
        }
    ]

    # ------------------------ Description -------------------------
    # CHECKPOINT
    # Install and Config FLUX 1 SCHNELL FP8 models ( DoubleCLIP + VAE + DIFFUSERS MODEL )
    #
    # ------------------------ Description -------------------------
    FLUX_1_SCHELDD_CHECKPOINT = [
        {
            "name": "flux1-schnell_fp8.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/flux1-schnell_fp8.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/checkpoints/flux1-schnell_fp8.safetensors",
            "URL" : "https://huggingface.co/Comfy-Org/flux1-schnell/resolve/main/flux1-schnell-fp8.safetensors"
        }
    ]

    # ------------------------ Description -------------------------
    #
    # Install and Config FLUX DEV UNIONS CONTROLNET models ( DoubleCLIP + VAE + DIFFUSERS MODEL )
    #
    # ------------------------ Description -------------------------
    FLUX_DEV_UNIONS_CONTROLNET = [
        {
            "name": "flux_dev_unions_controls.safetensors",
            "path_mount": f"{PATH_TO_MOUNT}/flux_dev_unions_controls.safetensors",
            "path_comfy": f"{PATH_TO_COMFY}/models/controlnet/flux_dev_unions_controls.safetensors",
            "URL": "https://huggingface.co/Shakker-Labs/FLUX.1-dev-ControlNet-Union-Pro/resolve/main/diffusion_pytorch_model.safetensors"
        }
    ]

    InstallModel("FLUX_1_DEV", FLUX_1_DEV, "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")
    InstallModel("STABLE_DIFFUSION", STABLE_DIFFUSION, "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")
    InstallModel("LORA_ULTRAREALIST", LORA_ULTRAREALIST, "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")
    InstallModel("FLUX_1_SCHELDD", FLUX_1_SCHELDD_UNET, "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")
    InstallModel("FLUX_1_SCHELDD", FLUX_1_SCHELDD_CHECKPOINT, "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")
    InstallModel("FLUX_DEV_UNIONS_CONTROLNET", FLUX_DEV_UNIONS_CONTROLNET, "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")