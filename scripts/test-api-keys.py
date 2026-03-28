#!/usr/bin/env python3
"""
Test script to validate Gemini and Groq API keys
"""

import os
import sys
import json
from pathlib import Path

# Add backend to path so we can import modules
backend_path = Path(__file__).parent.parent / "backend" / "simple_backend"
sys.path.insert(0, str(backend_path))

# Colors for output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def print_header(title):
    """Print a formatted header"""
    print(f"\n{BLUE}{'='*60}")
    print(f"{title}")
    print(f"{'='*60}{RESET}\n")

def print_success(msg):
    """Print success message"""
    print(f"{GREEN}✅ {msg}{RESET}")

def print_error(msg):
    """Print error message"""
    print(f"{RED}❌ {msg}{RESET}")

def print_warning(msg):
    """Print warning message"""
    print(f"{YELLOW}⚠️  {msg}{RESET}")

def print_info(msg):
    """Print info message"""
    print(f"{BLUE}ℹ️  {msg}{RESET}")

def load_env():
    """Load environment from .env file"""
    env_file = backend_path / ".env"
    
    if not env_file.exists():
        print_error(f"Environment file not found: {env_file}")
        return False
    
    # Read and source the .env file
    with open(env_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                # Remove 'export ' prefix if present
                if line.startswith('export '):
                    line = line[7:]
                # Parse KEY=VALUE
                if '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key.strip()] = value.strip()
    
    return True

def test_gemini():
    """Test Gemini API key"""
    print_header("Testing Gemini API")
    
    api_key = os.environ.get('GEMINI_API_KEY')
    
    if not api_key:
        print_error("GEMINI_API_KEY not found in environment")
        return False
    
    if api_key == 'your_gemini_api_key_here':
        print_error("GEMINI_API_KEY is still a placeholder")
        return False
    
    print_info(f"API Key: {api_key[:20]}...{api_key[-10:]}")
    
    try:
        import google.generativeai as genai
    except ImportError:
        print_warning("google-generativeai not installed. Installing...")
        os.system(f"{sys.executable} -m pip install -q google-generativeai")
        try:
            import google.generativeai as genai
        except ImportError:
            print_error("Failed to install google-generativeai")
            return False
    
    try:
        genai.configure(api_key=api_key)
        
        # Just list models to validate key - don't make requests (avoids quota)
        models = genai.list_models()
        model_list = [m for m in models if 'generateContent' in m.supported_generation_methods]
        
        if not model_list:
            print_error("No generative models available")
            return False
        
        print_success(f"Gemini API Key is VALID ✨")
        print_info(f"Found {len(model_list)} generative models available")
        
        # List some available models
        print_info("Available models:")
        for model in model_list[:3]:
            print(f"  - {model.name}")
        if len(model_list) > 3:
            print(f"  ... and {len(model_list) - 3} more")
        
        return True
            
    except Exception as e:
        print_error(f"Gemini API Error: {str(e)}")
        return False

def test_groq():
    """Test Groq API key"""
    print_header("Testing Groq API")
    
    api_key = os.environ.get('GROQ_API_KEY')
    
    if not api_key:
        print_error("GROQ_API_KEY not found in environment")
        return False
    
    if api_key == 'your_groq_api_key_here':
        print_error("GROQ_API_KEY is still a placeholder")
        return False
    
    print_info(f"API Key: {api_key[:20]}...{api_key[-10:]}")
    
    try:
        from groq import Groq
    except ImportError:
        print_warning("groq not installed. Installing...")
        os.system(f"{sys.executable} -m pip install -q groq")
        try:
            from groq import Groq
        except ImportError:
            print_error("Failed to install groq")
            return False
    
    try:
        client = Groq(api_key=api_key)
        
        # Try different models - some might be deprecated
        models_to_try = [
            "llama-3.3-70b-versatile",
            "llama-3.2-90b-vision-preview", 
            "mixtral-8x7b",
            "llama-3.1-405b-reasoning"
        ]
        
        success = False
        last_error = None
        
        for model_name in models_to_try:
            try:
                message = client.chat.completions.create(
                    messages=[
                        {"role": "user", "content": "Hello"}
                    ],
                    model=model_name,
                    max_tokens=10,
                )
                
                if message.choices[0].message.content:
                    print_success(f"Groq API Key is VALID ✨")
                    print_info(f"Successfully used model: {model_name}")
                    print_success(f"Response: '{message.choices[0].message.content[:50]}'")
                    success = True
                    break
            except Exception as e:
                last_error = str(e)
                if "401" in last_error or "Unauthorized" in last_error or "authentication" in last_error.lower():
                    print_error(f"Groq API Key is INVALID: {last_error}")
                    return False
                # Try next model if this one fails
                continue
        
        if success:
            return True
        else:
            # If all models failed due to deprecation, key is still valid
            if last_error and ("decommissioned" in last_error or "deprecated" in last_error):
                print_success(f"Groq API Key is VALID ✨")
                print_warning(f"Note: Tested models are deprecated. Please update your code.")
                print_info(f"Visit https://console.groq.com/docs/models for current models")
                return True
            else:
                print_error(f"Groq API Error: {last_error}")
                return False
            
    except Exception as e:
        error_msg = str(e)
        if "401" in error_msg or "Unauthorized" in error_msg:
            print_error(f"Groq API Key is INVALID: Unauthorized (401)")
        elif "403" in error_msg:
            print_error(f"Groq API Key is INVALID: Forbidden (403)")
        else:
            print_error(f"Groq API Error: {error_msg}")
        return False

def main():
    """Main test runner"""
    print(f"{BLUE}")
    print("╔════════════════════════════════════════════════════════════╗")
    print("║             API KEYS VALIDATION TEST SUITE                 ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print(f"{RESET}")
    
    # Load environment
    if not load_env():
        print_error("Failed to load environment")
        sys.exit(1)
    
    print_success("Environment loaded from .env")
    
    results = {
        'gemini': False,
        'groq': False
    }
    
    # Test Gemini
    results['gemini'] = test_gemini()
    
    # Test Groq
    results['groq'] = test_groq()
    
    # Summary
    print_header("Test Summary")
    print(f"Gemini API: {'✅ PASS' if results['gemini'] else '❌ FAIL'}")
    print(f"Groq API:   {'✅ PASS' if results['groq'] else '❌ FAIL'}")
    
    if all(results.values()):
        print_success("\nAll API keys are valid and working! 🎉")
        print_info("You can now run: mprocs")
        return 0
    else:
        failed = [k for k, v in results.items() if not v]
        print_error(f"\nFailed tests: {', '.join(failed)}")
        print_warning("Please check your API keys and try again")
        return 1

if __name__ == "__main__":
    sys.exit(main())
