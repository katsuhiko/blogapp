<?php

class CreatePosts extends CakeMigration {

	/**
	 * Migration description
	 *
	 * @var string
	 */
	public $description = 'create_posts';

	/**
	 * Actions to be performed
	 *
	 * @var array $migration
	 */
	public $migration = [
		'up' => [
			'create_table' => [
				'posts' => [
					'id' => ['type' => 'integer', 'null' => false, 'default' => null, 'key' => 'primary'],
					'title' => ['type' => 'string', 'null' => false, 'default' => null, 'length' => 255],
					'body' => ['type' => 'text', 'null' => true, 'default' => null],
					'created' => ['type' => 'datetime', 'null' => false, 'default' => null],
					'modified' => ['type' => 'datetime', 'null' => false, 'default' => null],
					'indexes' => [
						'PRIMARY' => ['column' => 'id', 'unique' => true],
					],
				],
			],
		],
		'down' => [
			'drop_table' => [
				'posts'
			],
		],
	];

	/**
	 * Before migration callback
	 *
	 * @param string $direction Direction of migration process (up or down)
	 * @return bool Should process continue
	 */
	public function before($direction) {
		return true;
	}

	/**
	 * After migration callback
	 *
	 * @param string $direction Direction of migration process (up or down)
	 * @return bool Should process continue
	 */
	public function after($direction) {
		return true;
	}
}
