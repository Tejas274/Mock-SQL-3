with player_id_score as(
select
    first_player as player,
    first_score as score
from
Matches

union all

select
    second_player as player,
    second_score as score
from
  Matches )

, total_score_player as (
select
    player as player_id,
    sum(score) as total_score
 from player_id_score
group by player
order by player
)

, player_with_rnk  as (
select
    players.player_id,
    players.group_id,
    ROW_number() over (partition by group_id order by total_score desc,player_id) as rnk
from
   total_score_player tsp
inner join
   players
on
  tsp.player_id = players.player_id
)

select group_id,player_id
from
player_with_rnk
where rnk = 1