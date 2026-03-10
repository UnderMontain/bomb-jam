extends EntityDamagable
class_name EnemyState

signal died



func take_damage(amount) -> int :
	hp -= amount
	
	if hp <= 0:
		GameManager.enqueue_action(DestroyEntityAction.new(self))
	
	
	return hp

func destroy(game_manager: GameManager):
	game_manager.emit_event(EventType.ENEMY_KILLED,{
		"source": self
	})
	died.emit()


func attack(player: Player):
	player.take_damage(1)
