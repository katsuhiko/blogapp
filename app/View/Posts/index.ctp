<nav class="navbar">
	<div class="collapse navbar-collapse">
		<p class="navbar-text navbar-right">
			<?php echo $this->Html->link(__('新規投稿'), ['action' => 'add'], ['class' => 'btn btn-default']); ?>
		</p>
	</div>
</nav>
<?php foreach ($posts as $post): ?>
	<selection>
		<h1><?php echo h($post['Post']['title']); ?></h1>
		<?php echo h($post['Post']['body']); ?>
		<p class="actions">
			<?php echo $this->Html->link(__('記事の編集'), [
				'action' => 'edit', $post['Post']['id']
			], ['class' => 'btn btn-success']); ?>
			<?php echo $this->Form->postLink(__('記事の削除'), [
				'action' => 'delete', $post['Post']['id']
			], null, __('記事「%s」を削除してもよろしいですか？', $post['Post']['title'])); ?>
		</p>
	</selection>
<?php endforeach; ?>
<ul class="pagination">
	<?php
	echo $this->Paginator->prev('&laquo;', [
		'escape' => false, 'tag' => 'li'
	], null, [
		'class' => 'prev disabled', 'escape' => false, 'tag' => 'li', 'disabledTag' => 'a'
	]);

	echo $this->Paginator->numbers([
		'separator' => '', 'tag' => 'li', 'currentTag' => 'a', 'currentClass' => 'active'
	]);

	echo $this->Paginator->next('&raquo;', [
		'escape' => false, 'tag' => 'li'
	], null, [
		'class' => 'next disabled', 'escape' => false, 'tag' => 'li', 'disabledTag' => 'a'
	]);
	?>
</ul>
