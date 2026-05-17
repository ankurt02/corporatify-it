# Corporate Filter# Corporate-Speak Transformer

## 🚀 Overview
The **Corporate-Speak Transformer** is a full-stack AI "Style Transfer" application designed to translate informal, frustrated, slang-heavy, or abusive language into polished, professional, and sophisticated "Corporate Speak." 

Whether you're drafting an email after a frustrating meeting or need to professionalize your tone, this app takes your raw input and seamlessly outputs an executive-level corporate equivalent.

## 📸 Screenshots

### Web UI
![](https://github.com/user-attachments/assets/de188e99-f082-4201-ac9f-d60587657e4d)

### Demo on local - using LM Studio
![](https://github.com/user-attachments/assets/c11b2491-a253-4d82-8521-333b3c712b80)

<br>
<br>

## 🛠️ Tech Stack
This project leverages a modern Client-Server-Model architecture to keep the frontend lightweight while handling heavy AI inference on a dedicated backend:

* **Frontend**: Flutter (Web), deployed live via **GitHub Pages** using GitHub Actions CI/CD pipeline.
* **Backend API**: Python **FastAPI** server containerized using Docker.
* **Hosting**: **Hugging Face Spaces** (Free CPU tier).
* **Inference Engine**: `llama-cpp-python` (Highly optimized C++ wrapper for blazing-fast CPU inference).
* **AI Training Stack**: Google Colab (T4 GPU), **Unsloth** library (QLoRA 4-bit quantization for Parameter-Efficient Fine-Tuning).

<br>
<br>

## Model & Fine-Tuning Details

- **Base Model**: The project uses the **Microsoft Phi-3.5 Mini** model, a lightweight yet powerful **3.8B parameter** language model optimized for efficient inference and instruction-following tasks.

- **Fine-Tuning Approach**: The model was fine-tuned on a synthetic dataset containing approximately **7,500 parallel training pairs**, where emotionally charged or frustrated raw text was mapped into professional corporate-style translations. Through supervised fine-tuning, the model learned to naturally capture latent semantic features such as **emotion, tone, frustration level, and intensity** directly from raw input text, without requiring handcrafted rules or multi-stage NLP pipelines.

- **GGUF Quantization**: To make deployment feasible on low-resource environments and CPU-based inference systems, the fine-tuned model was converted into **GGUF format using Q4_K_M 4-bit quantization**. This significantly reduced the memory footprint while maintaining strong generation quality, enabling fast and practical inference even without high-end GPU hardware.

- **Inference Stack**: The quantized GGUF model is served using lightweight local inference runtimes, making the system suitable for cost-efficient deployment and experimentation in constrained environments.
  
<br>
<br>

### 🔗 Where to get the model
The fine-tuned model and its optimized GGUF versions are publicly available on the Hugging Face Model Hub, and can also be downloaded directly within **LM Studio**:

* **GGUF (Optimized for CPU Inference)**: [ankurt02/corporate-filter-phi35-mini-merged-Q4_K_M-GGUF](https://huggingface.co/ankurt02/corporate-filter-phi35-mini-merged-Q4_K_M-GGUF)
* **Base Merged Weights**: [ankurt02/corporate-filter-phi35-mini-merged](https://huggingface.co/ankurt02/corporate-filter-phi35-mini-merged)
* **LM Studio**: You can run this model locally with zero setup! Just open LM Studio, search for `ankurt02/corporate-filter` in the home screen search bar, and download the `Q4_K_M` GGUF file to run it instantly on your own hardware.

<br>
<br>

## ⚡ Response Time Performance

### 1. Cloud Deployment (Hugging Face Free Space)
Running standard LLMs on free cloud CPUs is incredibly slow. Our initial architecture utilizing the standard `transformers` library resulted in response times exceeding 9 to 11 minutes per request. 

### 2. Local Testing (LM Studio)
For local development, the GGUF model can be loaded directly into **LM Studio**. By acting as a Local Inference Server, LM Studio taps directly into local hardware (RAM/GPU). This provides near-instantaneous response times, entirely bypassing serverless timeouts, network latency, and the need for complex Docker setups on your local machine.

