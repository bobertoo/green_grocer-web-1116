def consolidate_cart(cart)
  new_cart = {}
  cart.each do |individual_item|
    individual_item.each do |item_name, item_deetz|
      if new_cart[item_name]
        new_cart[item_name][:count] += 1
      else
        item_deetz[:count] = 1
        new_cart[item_name] = item_deetz
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  counter = 0
  while counter < coupons.length
    if cart[coupons[counter][:item]]
      if cart[coupons[counter][:item]][:count] >= coupons[counter][:num]
        coupon_counter = 0
        while cart[coupons[counter][:item]][:count] >= 0
          cart[coupons[counter][:item]][:count] -= coupons[counter][:num]
          coupon_counter += 1
        end
        if cart[coupons[counter][:item]][:count] < 0
          cart[coupons[counter][:item]][:count] += coupons[counter][:num]
          coupon_counter -= 1
        end
        cart[coupons[counter][:item] + " W/COUPON"] = {}
        cart[coupons[counter][:item] + " W/COUPON"][:count] = coupon_counter
        cart[coupons[counter][:item] + " W/COUPON"][:price] = coupons[counter][:cost]
        cart[coupons[counter][:item] + " W/COUPON"][:clearance] = cart[coupons[counter][:item]][:clearance]
      end
    end
    counter += 1
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, item_deetz|
    if item_deetz[:clearance]
      item_deetz[:price] =  item_deetz[:price] - (item_deetz[:price] * 0.20)
    end
  end
end

def checkout(cart, coupons)
  total = 0.0
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  cart_with_clearance = apply_clearance(cart_with_coupons)
  cart_with_clearance.each do |item, item_deetz|
    total += item_deetz[:price] * item_deetz[:count]
  end
  if total > 100.0
    total = total - (total * 0.1)
  end
  total
end
