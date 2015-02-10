<?php

/**
 * PostFixture
 *
 */
class PostFixture extends CakeTestFixture {

	/**
	 * Import
	 *
	 * @var array
	 */
	public $import = ['model' => 'Post'];

	/**
	 * Records
	 *
	 * @var array
	 */
	public $records = [
		[
			'id' => 1,
			'title' => 'Lorem ipsum dolor sit amet',
			'body' => 'Lorem ipsum dolor sit amet, aliquet feugiat. Convallis morbi fringilla gravida, phasellus feugiat dapibus velit nunc, pulvinar eget sollicitudin venenatis cum nullam, vivamus ut a sed, mollitia lectus. Nulla vestibulum massa neque ut et, id hendrerit sit, feugiat in taciti enim proin nibh, tempor dignissim, rhoncus duis vestibulum nunc mattis convallis.',
			'created' => '2015-02-10 05:49:48',
			'modified' => '2015-02-10 05:49:48'
		],
	];

}
