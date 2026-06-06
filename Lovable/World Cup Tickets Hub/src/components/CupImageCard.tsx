import React, { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import type { LucideIcon } from 'lucide-react';

interface CupImageCardProps {
  /** Ano da Copa — usado para montar o caminho /{dir}/{year}.avif */
  year: number;
  /** Subpasta em /public (ex.: 'balls', 'mascots'). */
  dir: string;
  /** Título do card (ex.: 'Bola oficial', 'Mascote oficial'). */
  title: string;
  /** Nome do item, exibido como legenda (opcional). */
  label?: string;
  /** Ícone lucide exibido ao lado do título. */
  Icon: LucideIcon;
}

/**
 * Card genérico para exibir um asset visual de uma Copa a partir de
 * /{dir}/{year}.avif (ex.: bola oficial, mascote). Se o arquivo não
 * existir, o componente se oculta por completo — fallback gracioso,
 * nenhuma área quebrada aparece.
 */
const CupImageCard: React.FC<CupImageCardProps> = ({ year, dir, title, label, Icon }) => {
  const [failed, setFailed] = useState(false);
  if (failed) return null;

  const src = `/${dir}/${year}.avif`;
  const alt = label ? `${title}: ${label}` : `${title} da Copa de ${year}`;

  return (
    <Card className="rounded-2xl border-border bg-gradient-to-br from-primary/10 to-transparent">
      <CardContent className="p-6">
        <div className="flex items-center gap-2 mb-3">
          <Icon className="w-5 h-5 text-primary" />
          <span className="text-xs uppercase tracking-wider text-primary font-medium">
            {title}
          </span>
        </div>
        <div className="flex flex-col items-center text-center">
          <img
            src={src}
            alt={alt}
            onError={() => setFailed(true)}
            loading="lazy"
            className="w-40 h-40 object-contain drop-shadow-xl mb-3"
          />
          {label && <div className="font-display text-xl">{label}</div>}
        </div>
      </CardContent>
    </Card>
  );
};

export default CupImageCard;
