@echo off
title 🚀 Setup RAP-AI (Optimized for RTX 3050 8GB + i7 Gen 12)
echo ===============================================================
echo  ⚙️  Instalasi Miniconda (jika belum ada)
echo  🧠  Membuat Environment: rap-ai
echo  🧩  Kernel Name: Python (RAP-AI Optimized)
echo  ⚡  GPU: RTX 3050 (8GB VRAM) - CUDA 12.1
echo ===============================================================
echo.

REM === 1. Cek apakah conda sudah terinstall ===
where conda >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚙️  Conda belum terinstall. Mengunduh dan menginstal Miniconda...
    powershell -Command "Invoke-WebRequest -Uri https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -OutFile Miniconda3-latest-Windows-x86_64.exe"
    start /wait "" Miniconda3-latest-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /AddToPath=1 /S /D=%USERPROFILE%\Miniconda3
    del Miniconda3-latest-Windows-x86_64.exe
    echo ✅ Miniconda berhasil diinstal.
) else (
    echo ✅ Conda sudah tersedia.
)

echo.
echo 🧠 Membuat environment rap-ai...
call conda create -n rap-ai python=3.10 -y

echo.
echo 🔄 Mengaktifkan environment rap-ai...
call conda activate rap-ai

echo.
echo 📦 Membuat file requirements_main_optimized.txt (library utama)...
(
    echo torch
    echo torchvision
    echo torchaudio
    echo pandas
    echo numpy
    echo matplotlib
    echo seaborn
    echo scikit-learn
    echo datasets
    echo transformers==4.44.2
    echo tabulate
    echo tqdm
    echo pillow
    echo huggingface_hub
    echo ipykernel
    echo accelerate
    echo safetensors
) > requirements_main_optimized.txt

echo.
echo 🚀 Menginstal library dari requirements_main_optimized.txt ...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --upgrade
pip install --upgrade pip
pip install -r requirements_main_optimized.txt --index-url https://download.pytorch.org/whl/cu121 --extra-index-url https://pypi.org/simple

echo.
echo 🧩 Mendaftarkan kernel untuk VSCode / Jupyter...
python -m ipykernel install --user --name=rap-ai --display-name "Python (RAP-AI Optimized)"

echo.
echo 🗂️  Membuat folder penyimpanan model lokal...
mkdir models

echo.
echo 🚀 Mengunduh model Hugging Face yang cocok untuk GPU 8GB VRAM...
REM === Model ukuran sedang, aman untuk 8GB VRAM ===
huggingface-cli download facebook/deit-small-patch16-224 --local-dir models/deit-small-patch16-224
huggingface-cli download timm/tf_efficientnetv2_s.in21k --local-dir models/tf_efficientnetv2_s.in21k
huggingface-cli download google/vit-base-patch16-224-in21k --local-dir models/vit-base-patch16-224-in21k
huggingface-cli download aaraki/vit-base-patch16-224-in21k-finetuned-cifar10 --local-dir models/vit-base-patch16-224-in21k-finetuned-cifar10
huggingface-cli download apple/mobilevit-small --local-dir models/mobilevit-small
huggingface-cli download nateraw/vit-base-beans --local-dir models/vit-base-beans
REM === Model opsional yang agak besar (gunakan batch kecil bila dipakai) ===
huggingface-cli download microsoft/swin-base-patch4-window7-224 --local-dir models/swin-base-patch4-window7-224
huggingface-cli download facebook/convnext-base-224 --local-dir models/convnext-base-224

echo.
echo 💾 Menyimpan daftar paket lengkap ke requirements_full_optimized.txt ...
pip freeze > requirements_full_optimized.txt

echo.
echo ✅ Environment dan model telah siap untuk RTX 3050 (8GB)!
echo ===============================================================
echo  🔹 Environment : rap-ai
echo  🔹 Kernel Name : Python (RAP-AI Optimized)
echo  🔹 Folder Model : models/
echo  🔹 File Library : requirements_main_optimized.txt
echo  🔹 File Backup  : requirements_full_optimized.txt
echo ===============================================================
echo 💡 Tips:
echo  - Gunakan batch_size kecil (8-16) untuk ViT model
echo  - Aktifkan Mixed Precision (fp16) dengan 'torch.cuda.amp'
echo ===============================================================
pause
