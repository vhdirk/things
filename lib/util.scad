module xor(){
  difference(){
    for(i = [0 : $children - 1])
      child(i);
      intersection_for(i = [0: $children -1])
        child(i);
  }
}

// Hack to suppress warning from MCAD.
module test_square_pyramid() {}
