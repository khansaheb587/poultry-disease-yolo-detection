# ---- Base image: PyTorch + CUDA prebuilt (GPU-ready) ----
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

# ---- System dependencies (needed by opencv/ultralytics/PIL etc.) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory inside the container ----
WORKDIR /app

# ---- Install Python dependencies first (better Docker layer caching) ----
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Copy the rest of the project (notebooks, scripts, data.yaml, etc.) ----
COPY . .

# ---- Default command: launch Jupyter so the existing .ipynb notebooks can run as-is ----
# (Colab notebooks -> use Jupyter here instead of converting to .py, so nothing has to change)
EXPOSE 8888
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
