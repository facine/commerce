#!/bin/bash

set -e $DRUPAL_TI_DEBUG

# Ensure the right Drupal version is installed.
# Note: This function is re-entrant.
drupal_ti_ensure_drupal

# Add custom modules to drupal build.
cd "$DRUPAL_TI_DRUPAL_DIR"

# Download custom branches of address and composer_manager.
(
    # These variables come from environments/drupal-*.sh
    mkdir -p "$DRUPAL_TI_MODULES_PATH"
    cd "$DRUPAL_TI_MODULES_PATH"

    git clone --branch 8.x-1.x http://git.drupal.org/project/composer_manager.git
    git clone --branch 8.x-1.x http://git.drupal.org/project/address.git
    git clone --branch 8.x-1.x http://git.drupal.org/project/entity.git
    git clone --branch 8.x-1.x http://git.drupal.org/project/inline_entity_form.git
    git clone --branch 8.x-1.x http://git.drupal.org/project/state_machine.git
    git clone --branch 8.x-1.x http://git.drupal.org/project/profile.git
)

# Ensure the module is linked into the codebase.
drupal_ti_ensure_module_linked

# Initialize composer_manager.
php modules/composer_manager/scripts/init.php
composer drupal-rebuild
composer update -n --lock --verbose

# Enable the main Commerce modules.
drush en -y commerce_product commerce_order views views_ui
drush en -y commerce_cart
drush cache-rebuild
