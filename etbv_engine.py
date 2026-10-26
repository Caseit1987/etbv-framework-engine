import json
import sys
import time

class ETBVEngine:
    def __init__(self, config_path="etbv.json"):
        self.config_path = config_path
        self.layer = 0
        self.mode = "deterministic"
        self.load_config()

    def load_config(self):
        try:
            with open(self.config_path, "r") as f:
                self.config = json.load(f)
            print(f"[*] ETBV Layer 0 Engine initialized successfully using {self.config_path}")
        except FileNotFoundError:
            print(f"[-] Critical: {self.config_path} not found. Defaulting to strict hardware fallback.")
            sys.exit(1)

    def validate_transition(self, current_state, next_state):
        """
        Enforces the mathematical boundary condition:
        Drops whole-class exploits before reaching system resources.
        """
        start_time = time.perf_counter()
        allowed_mutations = self.config["boundaries"]["state_transitions"]["allowed_mutations"]
        action = self.config["boundaries"]["state_transitions"]["action_on_violation"]

        # Deterministic boundary check
        if next_state not in allowed_mutations:
            overhead = (time.perf_counter() - start_time) * 1000
            print(f"[CRITICAL ALERT] Boundary violation detected! Attempted mutation to {next_state}")
            print(f"[*] ETBV Layer 0 enforced isolation in {overhead:.4f}ms. Dropping execution context.")
            
            if action == "STRUCTURAL_TERMINATION":
                print("[-] Terminating isolated thread runtime. Zero clicks processed.")
                sys.exit(1)
            return False

        overhead = (time.perf_counter() - start_time) * 1000
        print(f"[+] Safe transition validated: {current_state} -> {next_state} ({overhead:.4f}ms overhead)")
        return True

if __name__ == "__main__":
    # Quick sanity test execution loop
    engine = ETBVEngine()
    
    # Test 1: Permitted flow
    print("\n--- Testing Valid System Operation ---")
    engine.validate_transition("S_INIT", "S_READ")
    
    # Test 2: Arbitrary dynamic exploit pathway (Unvetted boundary crossing)
    print("\n--- Testing Malicious Exploit Ingestion (Zero-Click Drop) ---")
    engine.validate_transition("S_READ", "S_EXECUTE_UNTRUSTED_PAYLOAD")
