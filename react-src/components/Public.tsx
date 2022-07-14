import React from 'react';
import { Link } from 'react-router-dom';

export const Public = () => {
  const content = (
    <section>
      <header>
        <h1>Welcome</h1>
      </header>
      <main>
        <p>
          Lorem ipsum dolor sit, amet consectetur adipisicing elit. Laborum
          consequuntur eius quibusdam, ea itaque necessitatibus quo similique id
          voluptatibus reprehenderit rem dolore at impedit doloremque facere
          sunt iste eum laboriosam!
        </p>
      </main>
      <footer>
        <Link to="/login">Login</Link>
      </footer>
    </section>
  );

  return content;
};
