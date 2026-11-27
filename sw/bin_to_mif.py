import sys

def convert_bin_to_mif(bin_filename, mif_filename, depth=1024, width=32):
    try:
        with open(bin_filename, "rb") as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: Binary file '{bin_filename}' not found.")
        sys.exit(1)

    words = []
    for i in range(0, len(content), 4):
        chunk = content[i:i+4]
        if len(chunk) < 4:
            chunk = chunk + b'\x00' * (4 - len(chunk))
        word = int.from_bytes(chunk, byteorder='little')
        words.append(f"{word:08X}")

    with open(mif_filename, "w") as f:
        f.write(f"WIDTH={width};\n")
        f.write(f"DEPTH={depth};\n\n")
        f.write("ADDRESS_RADIX=HEX;\n")
        f.write("DATA_RADIX=HEX;\n\n")
        f.write("CONTENT BEGIN\n")
        
        for idx, word in enumerate(words):
            f.write(f"    {idx:03X} : {word};\n")
            
        if len(words) < depth:
            f.write(f"    [{len(words):03X}..{depth-1:03X}] : 00000013;\n")
            
        f.write("END;\n")
    
    print(f"Successfully generated {mif_filename} with {len(words)} instructions.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python bin_to_mif.py <input.bin> <output.mif>")
        sys.exit(1)
    
    convert_bin_to_mif(sys.argv[1], sys.argv[2])
