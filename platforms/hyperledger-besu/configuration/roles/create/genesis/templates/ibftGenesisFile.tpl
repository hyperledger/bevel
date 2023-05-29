{
   "config": {
     "chainId":  {{ chain_id }},
     "constantinoplefixblock": 0,
     "contractSizeLimit": 2147483647,
     "ibft2": {
       "blockperiodseconds": 2,
       "epochlength": 30000,
       "requesttimeoutseconds": 10
     }
   },
   "nonce": "0x0",
   "timestamp": "0x58ee40ba",
   "gasLimit": "0x1fffffffffffff",
   "difficulty": "0x1",
   "alloc": {
{% if network.config.accounts is defined %}
{% for key in network.config.accounts %}
      "{{ key | quote }}":{
        "balance": "90000000000000000000000"
      }{{ "," if not loop.last else "" }}
{% endfor %}
{% endif %}
   }
}
