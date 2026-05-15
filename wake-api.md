### To wake up the hf-api

run the below command in terminal
``` 
pip install huggingface_hub
```

create a python file and run it with the following code :
```
from huggingface_hub import HfApi

# Initialize the API client
api = HfApi(token="YOUR_HF_TOKEN")

# Trigger the restart/wake up
try:
    api.restart_space(repo_id="ankurt02/corporate-filter-phi35-mini-merged")
    print("Space wake-up signal sent successfully!")
except Exception as e:
    print(f"Error waking up Space: {e}")
```


Or

execute the CURL command

```
curl -X POST \
  -H "Authorization: Bearer YOUR_HF_TOKEN" \
  https://huggingface.co/api/spaces/ankurt02/corporate-filter-phi35-mini-merged/restart
```
