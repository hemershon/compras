class DirectPurchaseStatus < EnumerateIt::Base
  associate_values :authorized, :unauthorized, :returned
end
