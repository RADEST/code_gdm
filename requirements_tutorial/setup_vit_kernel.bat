@echo off
title 🚀 Setup Kernel ViT-Gemastik (PyTorch 2.6 + CUDA 12.1)
echo ================================================
echo  Membuat Environment: gemastik-vit
echo  Kernel Name: Python (ViT-Gemastik)
echo ================================================
echo.

REM === 1. Buat environment baru ===
conda create -n gemastik-vit python=3.10 -y

REM === 2. Aktifkan environment ===
call conda activate gemastik-vit

REM === 3. Install ipykernel agar bisa dipakai di Jupyter/VSCode ===
pip install ipykernel
python -m ipykernel install --user --name=gemastik-vit --display-name "Python (ViT-Gemastik)"

REM === 4. Install library utama ===
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --upgrade
pip install pandas numpy matplotlib seaborn scikit-learn datasets transformers tabulate tqdm pillow

REM === 5. Simpan daftar paket untuk backup ===
pip freeze > requirements.txt

echo.
echo ✅ Environment dan kernel ViT-Gemastik sudah siap!
echo 📦 Kernel Name : Python (ViT-Gemastik)
echo 📘 Jalankan di VSCode atau Jupyter Notebook.
echo.
pause
