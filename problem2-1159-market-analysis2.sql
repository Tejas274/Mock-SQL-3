with user_item_sell_row_num as
(
    select
        seller_id,
        item_id,
        ROW_NUMBER() over (partition by seller_id order by order_date) as rnk
    from
        Orders
)

, item_name_rnk as(

    select
      uswrnk.item_id,
      uswrnk.seller_id,
      Items.item_brand
    from
    user_item_sell_row_num uswrnk
    inner join
    Items
    on uswrnk.item_id = Items.item_id
    where uswrnk.rnk = 2

)

select
   Users.user_id as seller_id,
   case
      when item_name_rnk.item_brand = Users.favorite_brand then 'yes'
      when item_name_rnk.item_brand != Users.favorite_brand then 'no'
      when item_name_rnk.item_brand is null then 'no'
      End AS 2nd_item_fav_brand
from
Users
left join
item_name_rnk
on Users.user_id = item_name_rnk.seller_id