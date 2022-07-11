import React from 'react';
import { render, screen } from '@testing-library/react';
import { App } from './App';

describe('App', () => {
  test('it renders the document with correct paragraph', () => {
    render(<App />);
    const paragraph = screen.getByText(/This is rendered by React/i);
    expect(paragraph).toBeInTheDocument();
  });
});
