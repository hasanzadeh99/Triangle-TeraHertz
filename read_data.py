import serial

def read_fixed_point_data(port, baudrate):
    try:
        # Open serial port
        ser = serial.Serial(port, baudrate, timeout=0.1)
        ser.reset_input_buffer()
        
        while True:
            # Read a line and process it
            line = ser.readline().decode('utf-8', errors='replace').strip()
            if line:
                try:
                    # Convert to integer
                    raw_value = int(line)
                    
                    # Extract integer and fraction parts (7-bit fraction)
                    integer_part = raw_value >> 7
                    fraction_part = raw_value & 0x7F
                    
                    # Calculate the actual value
                    actual_value = integer_part + (fraction_part / 128.0)
                    
                    # Display only the float value with 3 decimal places
                    print(f"{actual_value:.3f}, ", end="", flush=True)
                    
                except ValueError:
                    # Skip invalid data
                    pass
                    
    except KeyboardInterrupt:
        print("\nStopped by user")
    except Exception as e:
        print(f"\nError: {e}")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()
            print("\nPort closed")

if __name__ == "__main__":
    port = 'COM12'  # Replace with your port
    baudrate = 115200  # Match your STM32 setting
    read_fixed_point_data(port, baudrate)