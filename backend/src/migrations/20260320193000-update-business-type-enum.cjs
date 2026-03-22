"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('business', 'businessType', {
      type: Sequelize.ENUM(
        'Online',
        'open market',
        'physical',
        'Hybrid(online & physical)',
        'Shop'
      ),
      allowNull: false,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.changeColumn('business', 'businessType', {
      type: Sequelize.ENUM(
        'Online',
        'open market',
        'physical',
        'Hybrid(online & physical)'
      ),
      allowNull: false,
    });
  },
};