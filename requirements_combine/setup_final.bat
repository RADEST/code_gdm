@echo off
title 🚀 Vision-AI Workstation Setup (RTX 3050 Optimized + Offline Model Loader)
echo ===============================================================
echo  🧠  Membuat Environment Vision-AI (PyTorch + Timm + CUDA 11.8)
echo  💾  Install library dari requirementshehe.txt
echo  ⚙️  Eksekusi script: model_download.py
echo ===============================================================
echo.

REM === 1. Cek apakah conda sudah terinstall ===
where conda >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚙️ Conda belum terinstall. Mengunduh dan menginstal Miniconda...
    powershell -Command "Invoke-WebRequest -Uri https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -OutFile Miniconda3-latest-Windows-x86_64.exe"
    start /wait "" Miniconda3-latest-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /AddToPath=1 /S /D=%USERPROFILE%\Miniconda3
    del Miniconda3-latest-Windows-x86_64.exe
    echo ✅ Miniconda berhasil diinstal.
) else (
    echo ✅ Conda sudah tersedia.
)

echo.
echo 🧠 Membuat environment vision-ai...
call conda create -n vision-ai python=3.10 -y

echo.
echo 🔄 Mengaktifkan environment vision-ai...
call conda activate vision-ai

echo.
echo 🚀 Instalasi PyTorch CUDA 11.8 + Timm...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install timm==1.0.9

echo.
echo 📦 Menginstal sisa library dari requirementshehe.txt ...
REM ganti ipywidgets versi agar tidak error
powershell -Command "(Get-Content 'requirementshehe.txt') -replace 'ipywidgets==8.2.7','ipywidgets==8.1.2' | Set-Content 'requirementshehe_fixed.txt'"
pip install -r requirementshehe_fixed.txt

echo.
echo 🧩 Menambahkan kernel untuk VSCode / Jupyter...
python -m ipykernel install --user --name=vision-ai --display-name "Python (Vision-AI)"

echo.
echo 🗂️ Membuat folder untuk menyimpan model...
if not exist "model" mkdir model

echo.
echo ⚡ Mengecek apakah modul timm sudah terpasang...
python -c "import importlib.util, sys; sys.exit(0) if importlib.util.find_spec('timm') else sys.exit(1)"
if %errorlevel% neq 0 (
    echo ❌ timm belum terinstal dengan benar, menghentikan proses download model.
    pause
    exit /b
)

echo.
echo 🚀 Menjalankan script model downloader (model_download.py)
echo ===============================================================
python "model_download.py"
echo ===============================================================

echo.
echo 💾 Menyimpan daftar library akhir ke requirements_full_final.txt ...
pip freeze > requirements_full_final.txt

echo.
echo ✅ Setup selesai sepenuhnya!
echo ===============================================================
echo  🔹 Environment : vision-ai
echo  🔹 Kernel Name : Python (Vision-AI)
echo  🔹 Folder Model : model/
echo  🔹 File Library : requirementshehe_fixed.txt
echo  🔹 File Backup  : requirements_full_final.txt
echo ===============================================================
pause
