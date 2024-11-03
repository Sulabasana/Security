from cryptography.fernet import Fernet

# Function to generate and save the encryption key
def generate_key():
    key = Fernet.generate_key()
    with open("encryption_key.key", "wb") as key_file:
        key_file.write(key)
    print("Encryption key generated and saved to 'encryption_key.key'")
    return key

# Function to load the encryption key from a file
def load_key():
    with open("encryption_key.key", "rb") as key_file:
        return key_file.read()

# Function to encrypt data
def encrypt_data(data, key):
    fernet = Fernet(key)
    encrypted_data = fernet.encrypt(data.encode())
    return encrypted_data

if __name__ == "__main__":
    # Generate a key if not already created
    try:
        key = load_key()
        print("Encryption key loaded.")
    except FileNotFoundError:
        key = generate_key()

    # Get user input
    user_input = input("Enter the data to encrypt: ")

    # Encrypt the provided data
    encrypted_output = encrypt_data(user_input, key)

    print("\nEncrypted Data:")
    print(encrypted_output.decode())  # Displaying as a string for readability
