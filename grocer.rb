require 'pry'
def consolidate_cart(cart)
  items = []
  consolidated_hash = {}
  cart.each do |food|
    food.each do |gleb, floob|
      unless items.include?(gleb)
        items.push(gleb)
      end 
    end 
  end
  items.each do |item|
    consolidated_hash[item] = {price: 0.0, clearance: false, count: 0}
    cart.each do |foods|
      foods.each do|food, spec|
        if item == food 
          consolidated_hash[item][:price] = foods[food][:price]
          consolidated_hash[item][:clearance] = foods[food][:clearance]
          consolidated_hash[item][:count] += 1
        end 
      end
    end 
  end
  consolidated_hash
end

def apply_coupons(cart, coupons)
  
  new_cart = {}
  if coupons != []
    coupons.each do |coup|
      cart.each do |food, specs|
        blob = "#{food} W/COUPON"
        unless new_cart.keys.include?(blob)
          if coup[:item] == food
            new_cart[blob] = {price:0.0 , clearance:0.0 , count: 0.0}
          end
        end
        if coup[:item] == food
          if cart[food][:count] == coup[:num]
            new_cart[blob][:price] = coup[:cost]
            new_cart[blob][:count] += 1.0
            new_cart[blob][:clearance] = cart[food][:clearance]
            cart[food][:count] = cart[food][:count] - coup[:num]
            new_cart[food] = cart[food]
          elsif cart[food][:count] > coup[:num]
            new_cart[blob][:price] = coup[:cost]
            new_cart[blob][:count] += 1.0
            new_cart[blob][:clearance] = cart[food][:clearance]
            cart[food][:count] = cart[food][:count] - coup[:num]
            new_cart[food] = cart[food]
          else
            new_cart[food] = cart[food]
          end
        else 
          new_cart[food] = cart[food]
        end 
      end 
    end
    new_cart
  else 
    cart
  end
end

def apply_clearance(cart) 
  cart.each do |item, spec|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  baker = consolidate_cart(cart)
  baker = apply_coupons(baker, coupons)
  baker = apply_clearance(baker)
  total = 0.0
  baker.each do |item, spec|
    total += baker[item][:price] * baker[item][:count]
  end
  if total > 100
    total = (total * 0.8).round(2)
  end
  total
end
