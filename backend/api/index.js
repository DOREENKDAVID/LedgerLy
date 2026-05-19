// This import is for side-effects: it forces Vercel's bundler to include
// `mysql2` in the function bundle. Sequelize loads the driver via dynamic
// `require()`, which the bundler can't trace — without this line you get a
// runtime error: "Please install mysql2 package manually".
// If you later switch to Postgres, add: import 'pg'; import 'pg-hstore';
import 'mysql2';

import app from '../src/app.js';

export default app;
