<h2><?php echo __('新規記事登録'); ?></h2>
<div class="posts form">
	<?php echo $this->Form->create('Post', [
		'inputDefaults' => [
			'div' => 'form-group', 'wrapInput' => false, 'class' => 'form-control'
		], 'class' => 'well'
	]); ?>
	<?php echo $this->Form->input('title', ['label' => __('タイトル')]); ?>
	<?php echo $this->Form->input('body', ['label' => __('本文')]); ?>
	<?php echo $this->Form->submit(__('投稿'), ['class' => 'btn btn-default']); ?>
</div>
