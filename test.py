def calculate_values_with_dict(A_dict, sold=0, pold=0):
    print("Starting calculations with A values from dictionary")
    print("Step\t\tA\t\ts\t\tp\t\ts/p")
    print("-" * 60)
    
    # Keep track of current values
    s = sold
    p = pold
    
    # Iterate through steps 0 to 1023
    for i in range(1024):
        # Get A value for this step (default to 0 if step not in dictionary)
        A = A_dict.get(i, 0xAAA)
        
        # Calculate new s and p values
        s = sold + A * A * i
        p = pold + A * A
        
        # Calculate s/p ratio (handling division by zero)
        if p != 0:
            ratio = s / p
        else:
            ratio = float('inf')
        
        # Print current step values
        print(f"{i}\t\t{A}\t\t{s}\t\t{p}\t\t{ratio:.4f}")
        
        # Update old values for next iteration
        sold = s
        pold = p


# Example usage with dictionary
A_dict = {
    # 56: 345,    # A=1020 at step 10
    # 20: 22,     # A=500 at step 20
    30: 1023      # A=750 at step 30
}
calculate_values_with_dict(A_dict)

