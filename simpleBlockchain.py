# Implement a basic blockchain

import json
import hashlib
from time import time
from typing import Any, Dict, List, Optional

# class Block:
    # def __init__(self, index, timestamp, data, prev_hash):
    #     self.index = index
    #     self.timestamp = timestamp
    #     self.data = data
    #     self.prev_hash = prev_hash
    #     self.hash = self.calc_hash()

    # def calc_hash(self):
    #     hash_string = str(self.index) + str(self.timestamp) + str(self.data) + str(self.prev_hash)
    #     return hashlib.sha256(hash_string.encode()).hexdigest()
    
class Blockchain:
    def __init__(self):
        self.curr_transactions = []
        self.chain = []
        self.new_block(proof=200, prev_hash='1')
    
    def new_block(self, proof, prev_hash):
        block = {
            'index': len(self.chain) + 1,
            'timestamp': time(),
            'transactions': self.curr_transactions,
            'proof': proof,
            'prev_hash': prev_hash or self.hash(self.chain[-1]),
        }

        self.curr_transactions = []
        self.chain.append(block)
        return block
    
    def new_transaction(self, sender, recipient, amount):
        self.curr_transactions.append({
            'sender': sender,
            'recipient': recipient,
            'amount': amount,
        })

        return self.last_block['index'] + 1
    
    @property
    def last_block(self):
        return self.chain[-1]
    
    @staticmethod
    def hash(block):
        hash_string = json.dumps(block, sort_keys=True).encode()
        return hashlib.sha256(hash_string).hexdigest()

    def proof_of_work(self, last_proof):
        proof = 0
        while self.valid_proof(last_proof, proof) is False:
            proof += 1
        return proof
    
    @staticmethod
    def valid_proof(last_proof, proof):
        guess = f'{last_proof}{proof}'.encode()
        guess_hash = hashlib.sha256(guess).hexdigest()
        return guess_hash[:4] == "0000"
    
# Create the blcokchain
blockchain = Blockchain()

# Add transactions
blockchain.new_transaction(
        sender="aaa",
        recipient="bbb",
        amount=1,
    )

# Add new blocks
last_proof = blockchain.last_block['proof']
proof = blockchain.proof_of_work(last_proof)
blockchain.new_block(proof, None)

print(json.dumps(blockchain.chain, sort_keys=True))
